package favorites

import (
	"main/core"
	"main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type RemoveFavoriteController struct{}

func (RemoveFavoriteController) RemoveFavorite(c *gin.Context) {
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

	var exists bool
	core.DB.QueryRow("SELECT EXISTS (SELECT id FROM Users WHERE id=$1)", favUUID).Scan(&exists)

	if !exists {
		msg := "The account to add as favorite does not exist"

		l.Warnw(msg,
			"id: ", favUUID,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}
	query := `
	DELETE FROM favorites
	WHERE favorite_owner = $1 AND favorite_account = $2
	`
	_, err = core.DB.Exec(query, user, favUUID.String())

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	msg := "Favorite Account Removed Successfully"

	l.Infow(msg,
		"favorite_owner", user,
		"favorite_account", favUUID,
	)
	c.JSON(http.StatusCreated, gin.H{"msg": msg, "user_id": user})

}