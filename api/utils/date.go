package utils

import (
	"encoding/json"
	"strconv"
	"time"
)

type UnixTimestamp time.Time

func (t UnixTimestamp) MarshalJSON() ([]byte, error) {
	return []byte(strconv.FormatInt(time.Time(t).Unix(), 10)), nil
}

func (t *UnixTimestamp) UnmarshalJSON(b []byte) error {
	var timestamp int32
	err := json.Unmarshal(b, &timestamp)
	if err != nil {
		return err
	}
	*t = UnixTimestamp(time.Unix(int64(timestamp), 0))
	return nil
}

func (t UnixTimestamp) String() string {
	return time.Time(t).String()
}

func (t *UnixTimestamp) Time() *time.Time {
	if t != nil {
		res := time.Time(*t)
		return &res
	}
	return nil
}

func (t UnixTimestamp) Value() (interface{}, error) {
	return time.Time(t), nil
}

func (t *UnixTimestamp) Scan(v interface{}) error {
	value, ok := v.(time.Time)
	if ok {
		*t = UnixTimestamp(value)
		return nil
	}
	return nil
}
