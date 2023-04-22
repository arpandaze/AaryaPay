package main

import (
	"main/core"
	routes "main/endpoints"
	"main/telemetry"

	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

func Init() *gin.Engine {
	core.ConnectDatabase()
	core.ConnectRedis()

	router := gin.New()
	router.Use(otelgin.Middleware("aaryapay"))

	router.Use(telemetry.GinzapInstance)
	router.Use(ginzap.RecoveryWithZap(telemetry.Logger(nil), true))

	routes.RegisterRoutes(router)

	return router
}
