package main

import (
	auth "main/endpoints/auth"
	transaction "main/endpoints/transaction"
	utils "main/endpoints/utils"

	"github.com/gin-gonic/gin"
)

func NewRouter() *gin.Engine {
	router := gin.New()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	health := new(utils.HealthController)

	register := new(auth.RegisterController)
	login := new(auth.LoginController)
	two_fa := new(auth.TwoFaController)
	refresh := new(auth.RefreshController)

	verify := new(transaction.TransactionVerifyController)
	refresh_controller := new(transaction.RefreshController)

	router.GET("/health", health.Status)

	v1 := router.Group("v1")
	{
		authGroup := v1.Group("auth")
		{
			authGroup.GET("/register", register.Register)
			authGroup.GET("/login", login.Status)
			authGroup.GET("/2fa", two_fa.Status)
			authGroup.GET("/refresh", refresh.Status)
		}

		transactionGroup := v1.Group("transaction")
		{
			transactionGroup.GET("/verify", verify.Status)
			transactionGroup.GET("/refresh", refresh_controller.Status)
		}
	}

	return router
}
