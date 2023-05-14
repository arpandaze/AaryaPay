package tools

import (
	"context"
	"fmt"
	"main/core"
	. "main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
)

type AuthCheckController struct{}

func (AuthCheckController) AuthCheck(c *gin.Context) {
	user, err := core.GetActiveUser(c)
	l := Logger(c).Sugar()

	if err != nil {
		l.Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	var userName string
	row := core.DB.QueryRow(context.Background(), "SELECT first_name FROM Users WHERE id=$1", user)

	err = row.Scan(&userName)
	if err != nil {
		Logger(c).Sugar().Errorw("Failed to query user!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Internal Server Error", "context": TraceIDFromContext(c)})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"msg":    fmt.Sprintf("Hello, %s!", userName),
		"status": "ok",
	})
}
