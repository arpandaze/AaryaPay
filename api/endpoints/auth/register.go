package auth

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type RegisterController struct{}

func (RegisterController) Register(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "register",
	})
}
