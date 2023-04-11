package favorites

import (
	"main/core"
	"main/telemetry"
	"main/utils"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type RetrieveFavoriteController struct{}

func (RetrieveFavoriteController) RetrieveFavorites(c *gin.Context) {
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

	query := `
		SELECT u.id, u.first_name, u.middle_name, u.last_name, u.email, f.date_added
		FROM Users u
		JOIN Favorites f ON u.id = f.favorite_account
		JOIN Users f_owner ON f_owner.id = f.favorite_owner
		WHERE f_owner.id = $1
	`

	rows, err := core.DB.Query(query, user)

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	defer rows.Close()

	type favoriteRetrieve struct {
		Id         uuid.UUID `db:"id"`
		FirstName  string    `db:"first_name"`
		MiddleName string    `db:"middle_name"`
		LastName   string    `db:"last_name"`
		Email      string    `db:"email"`
		Date_Added string    `db:"date_added"`
	}

	var favList []favoriteRetrieve

	for rows.Next() {
		var fav favoriteRetrieve
		if err := rows.Scan(&fav.Id, &fav.FirstName, &fav.MiddleName, &fav.LastName, &fav.Email, &fav.Date_Added); err != nil {
			msg := "Failed to associate data with datastructure"

			l.Errorw(msg,
				"error", err, msg,
			)

			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
			return

		}
		favList = append(favList, fav)
	}

	if err = rows.Err(); err != nil {
		msg := "An error occured while retrieving data from the database"

		l.Errorw(msg,
			"error", err, msg,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	msg := "Data Fetched Successfully"

	l.Infow(msg,
		"user", user,
	)
	c.JSON(http.StatusAccepted, gin.H{"msg": msg, "data": favList})

}
