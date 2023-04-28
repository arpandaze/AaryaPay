package profile

import (
	"main/core"
	. "main/telemetry"
	. "main/utils"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type GetProfileController struct{}

func (GetProfileController) GetProfile(c *gin.Context) {
	user, err := core.GetActiveUser(c)
	l := Logger(c).Sugar()

	if err != nil {
		msg := "User not logged in!"
		Logger(c).Sugar().Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	var profileDataReturn struct {
		Id         uuid.UUID     `json:"id,omitempty" db:"id"`
		FirstName  string        `json:"first_name,omitempty" db:"first_name" `
		PhotoUrl   string        `json:"photo_url",omitempty db:"photo_url"`
		MiddleName string        `json:"middle_name,omitempty" db:"middle_name"`
		LastName   string        `json:"last_name,omitempty" db:"last_name"`
		DOB        UnixTimestamp `json:"dob,omitempty" db:"dob"`
		Email      string        `json:"email,omitempty" db:"email"`
	}

	var profileData = core.DB.QueryRow("SELECT id, first_name, middle_name, last_name, dob, email FROM Users WHERE id = $1", user)
	err = profileData.Scan(&profileDataReturn.Id, &profileDataReturn.FirstName, &profileDataReturn.MiddleName, &profileDataReturn.LastName, &profileDataReturn.DOB, &profileDataReturn.Email)

	if err != nil {
		l.Errorw("Error getting user profile!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	c.JSON(http.StatusAccepted, gin.H{"msg": "success", "data": profileDataReturn})
}
