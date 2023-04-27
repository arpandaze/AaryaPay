package profile

import (
	"main/core"
	"main/telemetry"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type GetProfileController struct{}

func (GetProfileController) GetProfile(c *gin.Context) {
	user, err := core.GetActiveUser(c)

	if err != nil {
		msg := "User not logged in!"
		telemetry.Logger(c).Sugar().Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	var profileDataReturn struct {
		FirstName  string    `json:"first_name,omitempty" db:"first_name" `
		PhotoUrl   string    `json:"photo_url",omitempty db:"photo_url"`
		MiddleName string    `json:"middle_name,omitempty" db:"middle_name"`
		LastName   string    `json:"last_name,omitempty" db:"last_name"`
		Dob        time.Time `json:"dob,omitempty" db:"dob"`
		Email      string    `json:"email,omitempty" db:"email"`
	}

	var profileData = core.DB.QueryRow("SELECT first_name, middle_name, last_name, dob, email FROM Users WHERE id = $1", user)
	profileData.Scan(&profileDataReturn.FirstName, &profileDataReturn.MiddleName, &profileDataReturn.LastName, &profileDataReturn.Dob, &profileDataReturn.Email)

	c.JSON(http.StatusAccepted, gin.H{"msg": "success", "data": profileDataReturn})
}
