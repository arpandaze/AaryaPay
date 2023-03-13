package auth

import (
	"database/sql"
	"main/core"
	"main/core/smtp"
	"net/http"

	"github.com/gin-gonic/gin"
)

type PasswordRecoveryController struct{}

func (PasswordRecoveryController) PasswordRecovery(c *gin.Context) {
	var email string
	if err := c.Bind(&email); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}
	queryUser := &core.CommonUser{}
	row := core.DB.QueryRow("SELECT (first_name, middle_name, last_name, email, pubkey_updated_at) FROM Users WHERE email=$1", email)
	err := row.Scan(&queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.Email, &queryUser.PubKeyUpdatedAt)

	switch err {
	case sql.ErrNoRows:
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "No account associated with the email exists"})
	case nil:
		res, resErr := smtp.SendResetPasswordEmail(queryUser)
		if res && resErr == nil {
			c.JSON(http.StatusAccepted, gin.H{"message": "Password recovery email has been sent"})
			return
		} else {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to send recovery email"})
			return
		}
	default:
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
		return
	}
}

func (PasswordRecoveryController) PasswordReset(c *gin.Context) {
	var resetPass struct {
		token        string
		new_password string
	}
	if err := c.Bind(&resetPass); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	uid, err := VerifyPasswordResetToken(resetPass.token)

	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "invalid or expired token"})
		return
	}

	passwordHash, err := core.HashPassword(c, resetPass.new_password)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password!"})
		return
	}

	_, err = core.DB.Exec("UPDATE Users SET password=$1 WHERE id=$2", passwordHash, uid)

	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
		return
	}

	c.JSON(http.StatusAccepted, gin.H{"message": "Password changed successfully"})

}

func VerifyPasswordResetToken(token string) (string, error) {
	return "", nil
}
