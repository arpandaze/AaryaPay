package auth

import (
	"context"
	"database/sql"
	"main/core"
	"main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
)

type PasswordChangeController struct{}

func (PasswordChangeController) PasswordChange(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	var passwordChange struct {
		Current_Password string `form:"current_password" validate:"required"`

		New_Password string `form:"new_password" validate:"required,min=8,max=128"`
	}

	if err := c.Bind(&passwordChange); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	user, err := core.GetActiveUser(c)

	if err != nil {
		l.Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	var queryPassword string
	row := core.DB.QueryRow(
		context.Background(),
		`
    SELECT password 
    FROM Users 
    WHERE id=$1
	`, user,
	)

	err = row.Scan(&queryPassword)

	if err == sql.ErrNoRows {
		msg := "No associated account was found"

		l.Warnw(msg,
			"id", user,
		)

		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}
	if err != nil {
		l.Errorw("Failed to execute SQL statement",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	passwordTest, err := core.VerifyPassword(c, passwordChange.Current_Password, queryPassword)
	if err != nil {
		msg := "Failed to verify password!"
		l.Warnw(msg, "error", err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}
	if !passwordTest {
		msg := "The password entered is incorrect"
		l.Warnw(msg,
			"id", user,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	passwordHash, err := core.HashPassword(c, passwordChange.New_Password)
	if err != nil {
		msg := "Failed to hash password!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	passwordTest, err = core.VerifyPassword(c, passwordChange.New_Password, queryPassword)
	if err != nil {
		msg := "Failed to verify password!"
		l.Warnw(msg, "error", err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	if passwordTest {
		msg := "The new password can not be the same as the old password"
		l.Warnw(msg,
			"id", user,
		)
		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	_, err = core.DB.Exec(context.Background(), "UPDATE Users SET password=$1 WHERE id=$2", passwordHash, user)

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	msg := "Password Changed Successfully"
	l.Infow(msg,
		"id", user,
	)
	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}
