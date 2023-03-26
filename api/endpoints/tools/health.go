package tools

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type HealthController struct{}

func (HealthController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
	})
}
