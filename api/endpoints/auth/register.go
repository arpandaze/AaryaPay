package auth

import (
	"fmt"
	"main/core"

	"net/http"
	// "time"

	// "github.com/google/uuid"

	"github.com/gin-gonic/gin"
)

type RegisterController struct{}

func (RegisterController) Register(c *gin.Context) {
	var user struct {
		FirstName  string `form:"first_name"`
		MiddleName string `form:"middle_name"`
		LastName   string `form:"last_name"`
		DOB        string `form:"dob"`
		Email      string `form:"email"`
		Password   string `form:"password"`
	}

	if err := c.Bind(&user); err != nil {
		fmt.Println(err)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	passwordHash, err := core.HashPassword(user.Password)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password!"})
		return
	}

	query := "INSERT INTO Users (first_name, middle_name, last_name, dob, password, email, pubkey_updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7)"

	_, err = core.DB.Exec(query, user.FirstName, user.MiddleName, user.LastName, user.DOB, passwordHash, user.Email, nil)
	if err != nil {
		fmt.Println(err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
		return
	}

	// Return success response
	c.JSON(http.StatusCreated, gin.H{"message": "User created successfully"})
}
