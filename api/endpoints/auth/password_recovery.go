package auth

import (
	"database/sql"
	"main/core"
	"main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
)

type PasswordRecoveryController struct{}

func (PasswordRecoveryController) PasswordRecovery(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	var recoverPassword struct {
		Email string `form:"email"`
	}
	if err := c.Bind(&recoverPassword); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	queryUser := &core.CommonUser{}
	row := core.DB.QueryRow(`
	SELECT id, first_name, middle_name, last_name, email, is_verified,pubkey_updated_at 
	FROM 
		Users 
	WHERE 
		email=$1
	`, recoverPassword.Email,
	)

	err := row.Scan(&queryUser.Id, &queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.Email, &queryUser.IsVerified, &queryUser.LastSync)

	switch err {
	case sql.ErrNoRows:

		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"email", recoverPassword.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
    return

	case nil:
		if !queryUser.IsVerified {
			msg := "Please verify the user first"
			l.Errorw(msg,
				"email", queryUser.Email)
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
			return
		}

		res, err := core.SendResetPasswordEmail(c, queryUser)

		if res && err == nil {
			msg := "Password recovery email has been sent"
			l.Infow(msg,
				"email", queryUser.Email,
			)
			c.JSON(http.StatusAccepted, gin.H{"msg": msg})
			return
		} else {
			msg := "Failed to send recovery email"
			l.Errorw(msg,
				"email", queryUser.Email)
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

func (PasswordRecoveryController) PasswordReset(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()
	var resetPass struct {
		token        string `form:"token"`
		new_password string `form:"new_password"`
	}
	if err := c.Bind(&resetPass); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	uid, err := VerifyPasswordResetToken(resetPass.token)

	if err != nil {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	passwordHash, err := core.HashPassword(c, resetPass.new_password)
	if err != nil {
		msg := "Failed to hash password!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	_, err = core.DB.Exec("UPDATE Users SET password=$1 WHERE id=$2", passwordHash, uid)

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}
	msg := "Password Reset Successfully"
	l.Infow(msg,
		"id", uid,
	)
	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}

func VerifyPasswordResetToken(token string) (string, error) {
	return "", nil
}
