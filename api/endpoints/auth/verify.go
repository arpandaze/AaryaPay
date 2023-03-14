package auth

import (
	"database/sql"
	"main/core"
	"main/core/smtp"
	"net/http"

	// "time"

	// "github.com/google/uuid"

	"github.com/gin-gonic/gin"
)

type VerifyController struct{}

func (VerifyController) VerifyUser(c *gin.Context) {
	l := core.Logger(c).Sugar()
	var verifyUser struct {
		Token string `form:"token"`
	}

	if err := c.Bind(&verifyUser); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	uid, err := VerifyUserToken(verifyUser.Token)

	if err != nil {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
		return
	}

	_, err = core.DB.Exec("UPDATE Users SET is_verified=$1 WHERE id=$2", "true", uid)

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": core.TraceIDFromContext(c)})
		return
	}
	msg := "User verified successfully"
	l.Infow(msg,
		"id", uid)

	c.JSON(http.StatusAccepted, gin.H{"msg": msg})

}

func (VerifyController) ResendVerificationEmail(c *gin.Context) {
	l := core.Logger(c).Sugar()
	var resendVerify struct {
		Email string `form:"email"`
		Token string `form:"token"`
	}
	if err := c.Bind(&resendVerify); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	uid, err := VerifyUserToken(resendVerify.Token)
	if err != nil {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
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

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg})
	case nil:
		res, err := smtp.SendVerificationEmail(queryUser)
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
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg})
			return
		}
	default:
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": core.TraceIDFromContext(c)})
		return
	}
}

func VerifyUserToken(token string) (string, error) {
	return "", nil
}