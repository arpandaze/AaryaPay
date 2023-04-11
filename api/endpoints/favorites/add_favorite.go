package favorites

import (
	"main/core"
	"main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type AddFavoriteController struct{}

func (AddFavoriteController) AddFavorite(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()
	var favInput struct {
		FavoriteAccount string `form:"favorite_account"`
	}

	if err := c.Bind(&favInput); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	favUUID, err := uuid.Parse(favInput.FavoriteAccount)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Error while parsing cookie",
			"error", err,
		)
		panic(err)
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

	if favUUID == uuid.Nil {
		msg := "Account to Favorite is required!"

		l.Warnw(msg,
			"favorite_account", favUUID)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	var userExists, favoriteExists bool
	query := `
		SELECT EXISTS(SELECT 1 FROM Users WHERE id = $1) AS user_exists,
    	EXISTS(SELECT 1 FROM Favorites WHERE favorite_owner = $2 AND favorite_account = $3) AS favorite_exists
	`

	core.DB.QueryRow(query, favUUID, user, favUUID).Scan(&userExists, &favoriteExists)

	if !userExists {
		msg := "The account to add as favorite does not exist!"

		l.Warnw(msg,
			"id: ", favUUID,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

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
	row := core.DB.QueryRow(query, user, favUUID.String())

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
	c.JSON(http.StatusCreated, gin.H{"msg": msg, "user_id": user})

}
