package auth

import (
	"database/sql"
	"main/core"
	"net/http"

	"github.com/gin-gonic/gin"
)

type LoginController struct{}

func (LoginController) Login(c *gin.Context) {
	var loginFormInput struct {
		Email    string `form:"email"`
		Password string `form:"password"`
	}
	type loginUser struct {
		ID              string `db:"id"`
		FirstName       string `db:"first_name"`
		MiddleName      string `db:"middle_name"`
		LastName        string `db:"last_name"`
		DOB             string `db:"dob"`
		Email           string `db:"email"`
		Password        string `db:"password"`
		IsVerified      string `db:"is_verified"`
		PubKey          string `db:"pubkey"`
		PubKeyUpdatedAt string `db:"pub_key_updated_at"`
	}

	if err := c.Bind(&loginFormInput); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	queryUser := &loginUser{}
	row := core.DB.QueryRow("SELECT (id,first_name,middle_name,last_name,dob,email,password,is_verified,pubkey,pub_key_updated_at) FROM Users WHERE email=$1", loginFormInput.Email)

	err := row.Scan(&queryUser.ID, &queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.DOB, &queryUser.Email, &queryUser.Password, &queryUser.IsVerified, &queryUser.PubKey, &queryUser.PubKeyUpdatedAt)

	switch err {
	case sql.ErrNoRows:
		c.AbortWithStatusJSON(http.StatusNotFound, gin.H{"error": "No account associated with the email exists"})
	case nil:
		passwordTest, err := core.VerifyPassword(c, loginFormInput.Password, queryUser.Password)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to verify password!"})
			return
		}
		if queryUser.Email == loginFormInput.Email {
			if passwordTest {
				//TODO: token generation and REDIS
				if queryUser.IsVerified == "true" {
					c.JSON(http.StatusAccepted, gin.H{"message": "Logged in Successful"})
					return
				} else {
					c.JSON(http.StatusUnauthorized, gin.H{"message": "Please Verify the Account First"})
					return
				}
			} else {
				c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "The password entered is incorrect"})
				return
			}
		}
	default:
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
		return
	}
}