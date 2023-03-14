package main

import (
	"main/core"
	routes "main/endpoints"

	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

func Init() *gin.Engine {
	core.LoadConfig()
	core.ConnectDatabase()

	router := gin.New()
	router.Use(otelgin.Middleware("aaryapay"))

	router.Use(core.GinzapInstance)
	router.Use(ginzap.RecoveryWithZap(core.Logger(nil), true))

	routes.RegisterRoutes(router)

	return router
}
