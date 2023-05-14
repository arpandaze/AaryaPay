package favorites

import (
	"context"
	"main/core"
	"main/telemetry"
	"main/utils"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type FavoriteUser struct {
	Id         uuid.UUID            `db:"id" json:"id"`
	FirstName  string               `db:"first_name" json:"first_name"`
	MiddleName string               `db:"middle_name" json:"middle_name,omitempty"`
	LastName   string               `db:"last_name" json:"last_name"`
	Email      string               `db:"email" json:"email"`
	DateAdded  *utils.UnixTimestamp `db:"date_added" json:"date_added"`
}

func GetFavoritesById(c *gin.Context, userId uuid.UUID) ([]FavoriteUser, error) {
	_, span := telemetry.Tracer.Start(c.Request.Context(), "GetFavoritesById()")
	defer span.End()
	l := telemetry.Logger(c).Sugar()

	query := `SELECT u.id, u.first_name, u.middle_name, u.last_name, u.email, f.date_added
	FROM Users u
	JOIN Favorites f ON u.id = f.favorite_account
	JOIN Users f_owner ON f_owner.id = f.favorite_owner
	WHERE f_owner.id = $1
	ORDER BY f.date_added ASC
	`

	rows, err := core.DB.Query(context.Background(), query, userId)

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		return nil, err
	}

	defer rows.Close()

	var favList []FavoriteUser

	for rows.Next() {
		var fav FavoriteUser
		if err := rows.Scan(&fav.Id, &fav.FirstName, &fav.MiddleName, &fav.LastName, &fav.Email, &fav.DateAdded); err != nil {
			msg := "Failed to associate data with datastructure"

			l.Errorw(msg,
				"error", err, msg,
			)

			return nil, err
		}
		favList = append(favList, fav)
	}

	if err = rows.Err(); err != nil {
		msg := "An error occured while retrieving data from the database"

		l.Errorw(msg,
			"error", err, msg,
		)

		return nil, err
	}

	return favList, nil
}

type RetrieveFavoriteController struct{}

func (RetrieveFavoriteController) RetrieveFavorites(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	user, err := core.GetActiveUser(c)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
		return
	}

	var exists bool
	core.DB.QueryRow(context.Background(), "SELECT EXISTS (SELECT id FROM Users WHERE id=$1)", user).Scan(&exists)

	if !exists {
		msg := "User does not exist"

		l.Warnw(msg,
			"id: ", user,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	favList, err := GetFavoritesById(c, user)

	if err != nil {
		l.Errorw("Failed to retrieve favorites",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	msg := "Data Fetched Successfully"

	l.Infow(msg,
		"user", user,
	)
	c.JSON(http.StatusOK, gin.H{"msg": msg, "data": favList})
}
