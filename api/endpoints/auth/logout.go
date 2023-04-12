package auth

import (
	"main/core"
	. "main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
)

type LogoutController struct{}

func (LogoutController) Logout(c *gin.Context) {
	_, err := core.GetUser(c)

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to get user from context",
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": "User not logged in!", "context": TraceIDFromContext(c)})
		return
	}

	// Get the session token from the cookie
	err = core.ExpireSession(c)

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to expire session",
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error!", "context": TraceIDFromContext(c)})
		return
	}

	// Delete the session cookie client side
	c.SetCookie("session", "", -1, "/", "", false, true)

	// Return a success response
	c.JSON(http.StatusOK, gin.H{"msg": "Logged out successfully!"})
}
