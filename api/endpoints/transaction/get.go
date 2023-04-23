package transaction

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type RefreshController struct{}

func (RefreshController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "transaction refresh",
	})
}
