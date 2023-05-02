package auth

import (
	"database/sql"
	"main/core"
	"main/telemetry"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
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
	SELECT id, first_name, middle_name, last_name, email, is_verified, last_sync
	FROM 
		Users 
	WHERE 
		email=$1
	`, recoverPassword.Email,
	)

	err := row.Scan(&queryUser.Id, &queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.Email, &queryUser.IsVerified, &queryUser.LastSync)

	if err == sql.ErrNoRows {
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"email", recoverPassword.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return

	}

	res, err := core.SendResetPasswordEmail(c, queryUser)

	if res && err == nil {
		msg := "Password recovery email has been sent"
		l.Infow(msg,
			"email", queryUser.Email,
		)
		c.JSON(http.StatusAccepted, gin.H{"msg": msg, "id": queryUser.Id})
		return
	} else {
		msg := "Failed to send recovery email"
		l.Errorw(msg,
			"email", queryUser.Email)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}
}

func (PasswordRecoveryController) PasswordReset(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()
	var resetPass struct {
		Id          string `form:"id"`
		Token       string `form:"token"`
		NewPassword string `form:"new_password" validate:"required,min=8,max=128"`
	}
	if err := c.Bind(&resetPass); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}
	err := core.Validator.Struct(resetPass)

	if err != nil {
		core.HandleValidationError(c, err)
		return
	}

	userID, parseErr := uuid.Parse(resetPass.Id)
	if parseErr != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to parse uuid!",
			"error", parseErr,
		)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": "Invalid user id!", "context": telemetry.TraceIDFromContext(c)})
		return
	}
	token, err := strconv.Atoi(resetPass.Token)

	if err != nil {
		msg := "Failed to parse Token"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	test := core.VerifyResetToken(c, userID, token)

	if !test {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	passwordHash, err := core.HashPassword(c, resetPass.NewPassword)
	if err != nil {
		msg := "Failed to hash password!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	_, err = core.DB.Exec("UPDATE Users SET password=$1 WHERE id=$2", passwordHash, resetPass.Id)

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
		"id", userID,
	)
	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}
