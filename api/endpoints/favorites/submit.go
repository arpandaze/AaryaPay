package favorites

import (
	"database/sql"
	"main/core"
	"main/telemetry"
	. "main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type AddFavoriteController struct{}

func (AddFavoriteController) AddFavorite(c *gin.Context) {
	l := Logger(c).Sugar()
	var favInput struct {
		Email string `form:"email"`
	}

	if err := c.Bind(&favInput); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	user, err := core.GetActiveUser(c)

	if err != nil {
		l.Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
		return
	}

	if favInput.Email == "" {
		msg := "Account to Favorite is required!"

		l.Warnw(msg,
			"id", user,
			"favorite_account", favInput.Email)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	var userID string
	err = core.DB.QueryRow("SELECT id FROM Users WHERE email = $1", favInput.Email).Scan(&userID)

	if err == sql.ErrNoRows {
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"id", user,
			"email", favInput.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	favUUID, err := uuid.Parse(userID)

	if err != nil {
		l.Errorw("Error while parsing UUID",
			"error", err,
		)
		return
	}

	if user == favUUID {
		msg := "Unable to add yourself as a favorite"
		l.Errorw("error", msg)
		c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	var favoriteExists bool
	query := `
		SELECT EXISTS(SELECT 1 FROM Favorites WHERE favorite_owner = $1 AND favorite_account = $2) AS favorite_exists
	`
	core.DB.QueryRow(query, user, favUUID).Scan(&favoriteExists)

	if favoriteExists {
		msg := "The account has already been added as favorite!"

		l.Warnw(msg,
			"favorite_owner ", user,
			"favorite_account", favUUID,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	query = `
      INSERT INTO favorites
      (
        favorite_owner,
		favorite_account
      )
      VALUES
      (
        $1,
        $2
      )
      RETURNING 
      date_added;
  `

	var r_date_added string
	row := core.DB.QueryRow(query, user, favUUID)

	err = row.Scan(&r_date_added)

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	msg := "Favorite Account Added Successfully"

	l.Infow(msg,
		"favorite_owner", user,
		"favorite_account", favUUID,
	)
	c.JSON(http.StatusCreated, gin.H{"msg": msg})
}
