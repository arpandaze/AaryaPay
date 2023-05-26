// MIT License
//
// # Copyright (c) 2023 Paul Milne
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package telemetry

import (
	"bytes"
	"compress/gzip"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"sync"
	"time"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

const lokiSinkKey = "loki"

type lokiSink interface {
	Sync() error
	Close() error
	Write(p []byte) (int, error)
}

// type lokiSink struct{}
type sink struct {
	lokiPusher *lokiPusher
}

func newSink(lp *lokiPusher) lokiSink {
	return sink{
		lokiPusher: lp,
	}
}

func (s sink) Sync() error  { return nil }
func (s sink) Close() error { return nil }

func (s sink) Write(p []byte) (int, error) {
	var entry logEntry
	err := json.Unmarshal(p, &entry)
	if err != nil {
		return 0, err
	}
	entry.raw = string(p)
	s.lokiPusher.entries <- entry
	return len(p), nil
}

type ZapLoki interface {
	Hook(e zapcore.Entry) error
	Sink(u *url.URL) (zap.Sink, error)
	Stop()
	WithCreateLogger(zap.Config) (*zap.Logger, error)
}

type Config struct {
	// Url of the loki server including http:// or https://
	Url string
	// BatchMaxSize is the maximum number of log lines that are sent in one request
	BatchMaxSize int
	// BatchMaxWait is the maximum time to wait before sending a request
	BatchMaxWait time.Duration
	// Labels that are added to all log lines,
	// each label becomes a stream
	Labels   map[string]string
	Username string
	Password string
}

type lokiPusher struct {
	config    *Config
	ctx       context.Context
	client    *http.Client
	quit      chan struct{}
	entries   chan logEntry
	waitGroup sync.WaitGroup
	streams   map[string]streamEntries
}

type lokiPushRequest struct {
	Streams []streams `json:"streams"`
}

type streams struct {
	Stream map[string]string `json:"stream"`
	Values [][2]string       `json:"values"`
}

type streamEntries struct {
	label string
	logs  [][2]string
}

type logEntry struct {
	Level     string  `json:"level"`
	Timestamp float64 `json:"ts"`
	Message   string  `json:"msg"`
	Caller    string  `json:"caller"`
	raw       string
}

func NewZapLoki(ctx context.Context, cfg Config) ZapLoki {
	c := &http.Client{}

	cfg.Url = strings.TrimSuffix(cfg.Url, "/")
	cfg.Url = fmt.Sprintf("%s/loki/api/v1/push", cfg.Url)

	pusher := &lokiPusher{
		config:  &cfg,
		ctx:     ctx,
		client:  c,
		quit:    make(chan struct{}),
		entries: make(chan logEntry),
		streams: make(map[string]streamEntries),
	}

	for id, label := range cfg.Labels {
		pusher.streams[id] = streamEntries{
			label: label,
			logs:  [][2]string{},
		}
	}

	pusher.waitGroup.Add(1)
	go pusher.run()
	return pusher
}

// Hook is a function that can be used as a zap hook to write log lines to loki
func (lp *lokiPusher) Hook(e zapcore.Entry) error {
	lp.entries <- logEntry{
		Level:     e.Level.String(),
		Timestamp: float64(e.Time.UnixMilli()),
		Message:   e.Message,
		Caller:    e.Caller.TrimmedPath(),
	}
	return nil
}

// Sink returns a new loki zap sink
func (lp *lokiPusher) Sink(_ *url.URL) (zap.Sink, error) {
	return newSink(lp), nil
}

// Stop stops the loki pusher
func (lp *lokiPusher) Stop() {
	close(lp.quit)
	lp.waitGroup.Wait()
}

// WithCreateLogger creates a new zap logger with a loki sink from a zap config
func (lp *lokiPusher) WithCreateLogger(cfg zap.Config) (*zap.Logger, error) {
	err := zap.RegisterSink(lokiSinkKey, lp.Sink)
	if err != nil {
		log.Fatal(err)
	}

	fullSinkKey := fmt.Sprintf("%s://", lokiSinkKey)

	if cfg.OutputPaths == nil {
		cfg.OutputPaths = []string{fullSinkKey}
	} else {
		cfg.OutputPaths = append(cfg.OutputPaths, fullSinkKey)
	}

	return cfg.Build()
}

func (lp *lokiPusher) run() {
	var batch []logEntry
	ticker := time.NewTimer(lp.config.BatchMaxWait)

	defer func() {
		if len(batch) > 0 {
			lp.send(batch)
		}

		lp.waitGroup.Done()
	}()

	for {
		select {
		case <-lp.ctx.Done():
			return
		case <-lp.quit:
			return
		case entry := <-lp.entries:
			batch = append(batch, entry)
			if len(batch) >= lp.config.BatchMaxSize {
				lp.send(batch)
				batch = make([]logEntry, 0)
				ticker.Reset(lp.config.BatchMaxWait)
			}
		case <-ticker.C:
			if len(batch) > 0 {
				lp.send(batch)
				batch = make([]logEntry, 0)
			}
			ticker.Reset(lp.config.BatchMaxWait)
		}
	}
}

func (lp *lokiPusher) send(batch []logEntry) error {
	data := lokiPushRequest{}

	for _, entry := range batch {
		ts := time.Unix(int64(entry.Timestamp), 0)
		v := [2]string{strconv.FormatInt(ts.UnixNano(), 10), entry.raw}
		for stream, streamEntries := range lp.streams {
			streamEntries.logs = append(streamEntries.logs, v)
			lp.streams[stream] = streamEntries
		}
	}

	for id, values := range lp.streams {
		s := streams{
			Stream: map[string]string{id: values.label},
			Values: values.logs,
		}
		data.Streams = append(data.Streams, s)
	}

	msg, err := json.Marshal(data)
	if err != nil {
		return fmt.Errorf("failed to marshal json: %w", err)
	}

	var buf bytes.Buffer
	g := gzip.NewWriter(&buf)
	if _, err := g.Write(msg); err != nil {
		return fmt.Errorf("failed to gzip json: %w", err)
	}
	if err := g.Close(); err != nil {
		return fmt.Errorf("failed to close gzip writer: %w", err)
	}

	req, err := http.NewRequest("POST", lp.config.Url, &buf)
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Content-Encoding", "gzip")

	if lp.config.Username != "" && lp.config.Password != "" {
		req.SetBasicAuth(lp.config.Username, lp.config.Password)
	}

	resp, err := lp.client.Do(req)
	if err != nil {
		return fmt.Errorf("failed to send request: %w", err)
	}

	defer resp.Body.Close()

	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("recieved unexpected response code from Loki: %s", resp.Status)
	}

	return nil
}
