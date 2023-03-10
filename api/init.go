package main

import (
	"main/core"
	routes "main/endpoints"

	"github.com/gin-gonic/gin"
)

func Init() *gin.Engine {
	core.LoadConfig()
  core.ConnectDatabase()

	router := gin.New()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	routes.RegisterRoutes(router)

	return router
}
