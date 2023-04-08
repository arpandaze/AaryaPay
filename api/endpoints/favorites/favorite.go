package favorites

import (
	"main/core"
	"main/telemetry"
	"main/utils"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type FavoriteController struct{}

func (FavoriteController) AddFavorite(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	user, err := utils.GetActiveUser(c)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
	}

	var exists bool
	core.DB.QueryRow("SELECT EXISTS (SELECT id FROM Users WHERE id=$1)", user).Scan(&exists)

	if !exists {
		msg := "User does not exist"

		l.Warnw(msg,
			"id: ", user,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	var favoriteInput struct {
		favorite_account uuid.UUID `form:"favorite_account"`
	}

	if err := c.Bind(&favoriteInput); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	if favoriteInput.favorite_account == uuid.Nil {
		msg := "Account to Favorite is required!"

		l.Warnw(msg,
			"favorite_account", favoriteInput.favorite_account)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
	}

	core.DB.QueryRow("SELECT EXISTS (SELECT id FROM Users WHERE id=$1)", favoriteInput.favorite_account).Scan(&exists)

	if !exists {
		msg := "The account to add as favorite does not exist"

		l.Warnw(msg,
			"id: ", favoriteInput.favorite_account,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	query := `
      INSERT INTO favorites
      (
        favorite_owner,
		favorite_account
      )
      VALUES
      (
        $1,
        $2,
      )
      RETURNING 
      date_added;
  `

	var r_date_added string
	row := core.DB.QueryRow(query, user, favoriteInput.favorite_account)

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
		"favorite_account", favoriteInput.favorite_account,
	)
	c.JSON(http.StatusCreated, gin.H{"msg": msg, "user_id": user})

}
