package user

import (
	"main/core"
	. "main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ProfileController struct{}
	var user struct {
		FirstName  string
		MiddleName string
		LastName   string
		DOB        date.Time
		Email      string
	}

func (ProfileController) ProfileGet(c *gin.Context) {
	l := Logger(c).Sugar()
	userID, err := core.GetActiveUser(c)

	if err != nil {
		l.Errorw("Failed to extract user!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

// CREATE TABLE Users (
//     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
//     photo_url VARCHAR(255),
//     first_name VARCHAR(50) NOT NULL,
//     middle_name VARCHAR(50),
//     last_name VARCHAR(50) NOT NULL,
//     dob DATE NOT NULL,
//     password VARCHAR(255) NOT NULL,
//     email VARCHAR(255) NOT NULL UNIQUE,
//     is_verified BOOLEAN DEFAULT false NOT NULL,
//     two_factor_auth VARCHAR(255),
//     last_sync TIMESTAMP,
//     created_at TIMESTAMP DEFAULT NOW()
// );

  // Query all user data
  var rows := core.DB.QueryRow("SELECT id, photo_url, first_name, middle_name, last_name, dob, email FROM Users WHERE id = $1", userID)


	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
	})
}

func (ProfileController) ProfileUpdate(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
	})
}

func (ProfileController) ProfileDelete(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
	})
}
