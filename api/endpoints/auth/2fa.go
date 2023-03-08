package auth

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type TwoFaController struct{}

func (TwoFaController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "2fa",
	})
}
