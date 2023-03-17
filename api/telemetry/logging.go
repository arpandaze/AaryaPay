package telemetry

import (
	"time"

	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel/trace"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func TraceIDFromContext(c *gin.Context) string {
	return trace.SpanFromContext(c.Request.Context()).SpanContext().TraceID().String()
}

func SpanIDFromContext(c *gin.Context) string {
	return trace.SpanFromContext(c.Request.Context()).SpanContext().SpanID().String()
}

func FieldsFromContext(c *gin.Context) []zapcore.Field {
	fields := []zapcore.Field{}
	// log trace and span ID
	if trace.SpanFromContext(c.Request.Context()).SpanContext().IsValid() {
		fields = append(fields, zap.String("trace_id", TraceIDFromContext(c)))
		fields = append(fields, zap.String("span_id", SpanIDFromContext(c)))
	}

	return fields
}

func initGinzap() (*zap.Logger, gin.HandlerFunc) {
	logger, _ := zap.NewProduction()

	ginzapInstance := ginzap.GinzapWithConfig(logger, &ginzap.Config{
		UTC:        true,
		TimeFormat: time.RFC3339,
		Context:    ginzap.Fn(FieldsFromContext),
	})

	return logger, ginzapInstance
}

var zinzapLogger, GinzapInstance = initGinzap()

func Logger(c *gin.Context) *zap.Logger {
	if c != nil {
		zinzapLogger.WithOptions()
		return zinzapLogger.With(FieldsFromContext(c)...)
	} else {
		return zinzapLogger
	}
}
