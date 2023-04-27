package auth

import (
	"database/sql"
	"main/core"
	"main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type ResendVerificationController struct{}

func (ResendVerificationController) ResendVerification(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	var resendVerification struct {
		id string `form:"id"`
	}

	var userID uuid.UUID

	if err := c.Bind(&resendVerification); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	queryUser := core.CommonUser{}
	row := core.DB.QueryRow(`
	SELECT id, first_name, middle_name, last_name, email, is_verified, last_sync
    FROM Users 
    LEFT JOIN Keys keys ON users.id = keys.associated_user AND keys.active = true
    LEFT JOIN Accounts a ON users.id = a.id
    WHERE id = $1;
	`, userID)

	err := row.Scan(&queryUser.Id, &queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.Email, &queryUser.IsVerified, &queryUser.LastSync)

	switch err {
	case sql.ErrNoRows:
		msg := "No account associated with the ID was found"

		l.Warnw(msg,
			"email", queryUser.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return

	case nil:
		_, err = core.SendVerificationEmail(c, &queryUser)
		if err != nil {
			telemetry.Logger(c).Sugar().Errorw("Failed to send verification email",
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
			return
		}
		msg := "Verification email sent successfully"
		c.JSON(http.StatusAccepted, gin.H{"msg": msg})
		return

	default:
		l.Errorw("Failed to execute SQL statement",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}
}
