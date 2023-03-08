package utils

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type HealthController struct{}

func (HealthController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
	})
}
