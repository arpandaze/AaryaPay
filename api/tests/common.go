package tests

import (
	"main/core"
	"main/telemetry"

	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

func TestMain() *gin.Engine {
	tracerShutdown := telemetry.InitTracer()
	defer tracerShutdown()
	return InitTestRouter()
}

func InitTestRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	core.LoadConfig("test")
	core.ConnectDatabase()
	core.ConnectRedis()

	router := gin.New()
	router.Use(otelgin.Middleware("aaryapay"))

	router.Use(telemetry.GinzapInstance)
	router.Use(ginzap.RecoveryWithZap(telemetry.Logger(nil), true))

	return router
}

var TestRouter *gin.Engine = TestMain()
