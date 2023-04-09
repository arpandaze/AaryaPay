package auth

import (
	"database/sql"
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

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	userID, parseErr := uuid.Parse(verifyUser.UserID)

	if parseErr != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to parse uuid!",
			"error", parseErr,
		)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": "Invalid user id!", "context": telemetry.TraceIDFromContext(c)})
	}

	verified := core.VerifyVerificationToken(c, userID, verifyUser.Token)

	if !verified {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token", "context": telemetry.TraceIDFromContext(c)})
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

func (VerifyController) ResendVerificationEmail(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()
	var resendVerify struct {
		Email string `form:"email"`
		Token string `form:"token"`
	}
	if err := c.Bind(&resendVerify); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	uid, err := VerifyUserToken(resendVerify.Token)
	if err != nil {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	queryUser := &core.CommonUser{}
	row := core.DB.QueryRow("SELECT (first_name, middle_name, last_name, email, pubkey_updated_at) FROM Users WHERE id=$1", uid)

	err = row.Scan(&queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.Email, &queryUser.PubKeyUpdatedAt)

	switch err {
	case sql.ErrNoRows:
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"email", queryUser.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
	case nil:
		res, err := core.SendVerificationEmail(c, queryUser)
		if res && err == nil {
			msg := "Account verification email has been sent"
			l.Infow(msg,
				"email", queryUser.Email,
			)
			c.JSON(http.StatusAccepted, gin.H{"msg": msg})
			return
		} else {
			msg := "Failed to send verification email"
			l.Errorw(msg,
				"email", queryUser.Email,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
			return
		}
	default:
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}
}

func VerifyUserToken(token string) (string, error) {
	return "", nil
}
