package profile

import (
	"main/core"
	. "main/telemetry"
	"main/utils"
	"mime/multipart"
	"net/http"

	"github.com/gin-gonic/gin"
)

type UpdateProfileController struct{}

func (UpdateProfileController) UpdateProfile(c *gin.Context) {
	l := Logger(c).Sugar()

	user, err := core.GetActiveUser(c)

	if err != nil {
		msg := "User not logged in!"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
		return
	}

	var profileUpdateData struct {
		FirstName  *string              `form:"first_name"`
		MiddleName *string              `form:"middle_name"`
		LastName   *string              `form:"last_name"`
		DOB        *utils.UnixTimestamp `form:"dob"`
	}

	if err := c.ShouldBind(&profileUpdateData); err != nil {
		msg := "Invalid request body!"
		l.Errorw(msg,
			"error", err,
			"data", profileUpdateData,
		)
		c.JSON(http.StatusBadRequest, gin.H{"error": msg, "context": TraceIDFromContext(c)})
		return
	}

	_, err = core.DB.Exec(`
    UPDATE Users
    SET first_name = COALESCE($1, first_name),
        middle_name = COALESCE($2, middle_name),
        last_name = COALESCE($3, last_name),
        dob = COALESCE($4, dob)
    WHERE id = $5
    `,
		profileUpdateData.FirstName, profileUpdateData.MiddleName, profileUpdateData.LastName, profileUpdateData.DOB.Time(), user,
	)

	if err != nil {
		l.Errorw("Error updating user profile!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	msg := "User profile updated!"
	l.Infow(msg)

	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}

func (UpdateProfileController) UpdateProfilePhoto(c *gin.Context) {
	l := Logger(c).Sugar()

	user, err := core.GetActiveUser(c)

	if err != nil {
		msg := "User not logged in!"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
		return
	}

	var fileHeader *multipart.FileHeader
	fileHeader, err = c.FormFile("photo")

	if err != nil {
		l.Errorw("Error getting file from request!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Failed to find file in request!", "context": TraceIDFromContext(c)})
		return
	}

	if fileHeader.Header.Get("Content-Type") != "image/png" && fileHeader.Header.Get("Content-Type") != "image/jpeg" {
		l.Errorw("Invalid file type!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": "Invalid file type!", "context": TraceIDFromContext(c)})

	}

	err = c.SaveUploadedFile(fileHeader, core.Configs.UPLOAD_DIR_ROOT+"/"+user.String())

	if err != nil {
		l.Errorw("Error opening file!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	_, err = core.DB.Exec(`
    UPDATE Users
    SET photo_url = $1
    WHERE id = $2
    `,
		user.String(), user,
	)

	if err != nil {
		l.Errorw("Error updating user profile!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	msg := "Profile picture updated!"
	l.Infow(msg)

	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}
