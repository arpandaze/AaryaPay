package auth

import (
	"main/core"
	"main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type VerifyController struct{}

func (VerifyController) VerifyUser(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()
	var verifyUser struct {
		UserID string `form:"user_id"`
		Token  int    `form:"token"`
	}

	if err := c.Bind(&verifyUser); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	userID, parseErr := uuid.Parse(verifyUser.UserID)

	if parseErr != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to parse uuid!",
			"error", parseErr,
		)
		panic(parseErr)
	}

	verified := core.VerifyVerificationToken(c, userID, verifyUser.Token)

	if !verified {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
		return
	}

	var err error
	_, err = core.DB.Exec("UPDATE Users SET is_verified=$1 WHERE id=$2", true, userID)

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}
	msg := "User verified successfully"
	l.Infow(msg,
		"id", verifyUser.UserID)

	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}