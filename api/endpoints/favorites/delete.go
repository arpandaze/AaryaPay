package favorites

import (
	"context"
	"database/sql"
	"fmt"
	"main/core"
	. "main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type RemoveFavoriteController struct{}

func (RemoveFavoriteController) RemoveFavorite(c *gin.Context) {
	l := Logger(c).Sugar()
	var favRemoveInput struct {
		Email string `form:"email"`
	}

	if err := c.Bind(&favRemoveInput); err != nil {
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

	fmt.Println("")
	fmt.Println(favRemoveInput.Email)
	fmt.Println("")
	if favRemoveInput.Email == "" {
		msg := "Account to remove favorite is required!"

		l.Warnw(msg,
			"id", user,
			"favorite_account", favRemoveInput.Email)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	var userID string
	err = core.DB.QueryRow(context.Background(), "SELECT id FROM Users WHERE email = $1", favRemoveInput.Email).Scan(&userID)

	if err == sql.ErrNoRows {
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"id", user,
			"email", favRemoveInput.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	} else if err != nil {
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

	var favoriteExists bool
	query := `
		SELECT EXISTS(SELECT 1 FROM Favorites WHERE favorite_owner = $1 AND favorite_account = $2) AS favorite_exists
	`
	core.DB.QueryRow(context.Background(), query, user, favUUID).Scan(&favoriteExists)

	if !favoriteExists {
		msg := "The account is not added as favorite!"

		l.Warnw(msg,
			"favorite_owner ", user,
			"favorite_account", favUUID,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	query = `
	DELETE FROM favorites
	WHERE favorite_owner = $1 AND favorite_account = $2
	`
	_, err = core.DB.Exec(context.Background(), query, user, favUUID.String())

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	msg := "Favorite Account Removed Successfully"

	l.Infow(msg,
		"favorite_owner", user,
		"favorite_account", favUUID,
	)
	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}
