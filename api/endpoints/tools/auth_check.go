package tools

import (
	"fmt"
	"main/core"
	"main/telemetry"
	"main/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

type AuthCheckController struct{}

func (AuthCheckController) AuthCheck(c *gin.Context) {
	user, err := utils.GetActiveUser(c)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
	}

	var userName string
	row := core.DB.QueryRow("SELECT first_name FROM Users WHERE id=$1", user)

	err = row.Scan(&userName)
	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to query user!",
			"error", err,
		)
		panic(err)
	}

	c.JSON(http.StatusOK, gin.H{
		"msg":    fmt.Sprintf("Hello, %s!", userName),
		"status": "ok",
	})
}
