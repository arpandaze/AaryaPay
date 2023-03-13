package auth

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type PasswordChangeController struct{}
func (PasswordChangeController) Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "refresh",
	})
}


// func (PasswordChangeController) PasswordChange(c *gin.Context) {
// 	var passwordChange struct{
// 		current_password string
// 		new_password string	`json:"new_password"`
// 	}
// 	if err := c.Bind(&email); err != nil {
// 		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
// 		return
// 	}
// 	queryUser := &core.CommonUser{}
// 	row := core.DB.QueryRow("SELECT (first_name, middle_name, last_name, email, pubkey_updated_at) FROM Users WHERE email=$1", email)
// 	err := row.Scan(&queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.Email, &queryUser.PubKeyUpdatedAt)

// 	switch err {
// 	case sql.ErrNoRows:
// 		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "No account associated with the email exists"})
// 	case nil:
// 		res, resErr := smtp.SendResetPasswordEmail(queryUser)
// 		if res && resErr == nil {
// 			c.JSON(http.StatusAccepted, gin.H{"message": "Password recovery email has been sent"})
// 			return
// 		} else {
// 			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to send recovery email"})
// 			return
// 		}
// 	default:
// 		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
// 		return
// 	}
// }


