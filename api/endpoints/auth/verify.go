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
	var token string

	if err := c.Bind(&token); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	uid, err := VerifyUserToken(token)

	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "invalid or expired token"})
		return
	}

	_, err = core.DB.Exec("UPDATE Users SET is_verified=$1 WHERE id=$2", "true", uid)

	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
		return
	}

	c.JSON(http.StatusAccepted, gin.H{"message": "User verified successfully"})


}

func (VerifyController) ResendVerificationEmail(c *gin.Context){

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
		res, resErr := smtp.SendVerificationEmail(queryUser)
		if res && resErr == nil {
			c.JSON(http.StatusAccepted, gin.H{"message": "Account verification email has been sent"})
			return
		} else {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to send verification email"})
			return
		}
	default:
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
		return
	}
}

func VerifyUserToken(token string) (string, error) {
	return "", nil
}
