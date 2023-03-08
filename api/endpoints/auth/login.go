package auth

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type LoginController struct{}

func (LoginController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "login",
	})
}
