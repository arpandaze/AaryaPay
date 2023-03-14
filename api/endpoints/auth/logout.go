package auth

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type LogoutController struct{}

func (LogoutController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "refresh",
	})
}

