package utils

import (
	"fmt"
	"main/core"
	"main/telemetry"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type UserExtractionError struct{}

func (r *UserExtractionError) Error() string {
	return fmt.Sprintf("Failed to extract user!")
}

func GetUser(c *gin.Context) (uuid.UUID, error) {
	_, span := telemetry.Tracer.Start(c.Request.Context(), "GetUser()")
	defer span.End()

	cookie, err := c.Cookie("session")

	cookieUUID, err := uuid.Parse(cookie)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Error while parsing cookie",
			"error", err,
		)
		panic(err)
	}

	user, err := core.GetUserFromSession(c, cookieUUID)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Error while getting user from session",
			"error", err,
		)
		return uuid.UUID{}, err
	} else {
		return user, nil
	}
}

func GetActiveUser(c *gin.Context) (uuid.UUID, error) {
	_, span := telemetry.Tracer.Start(c.Request.Context(), "GetActiveUser()")
	defer span.End()

	user, err := GetUser(c)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to extract user!",
			"error", err,
		)
		return uuid.UUID{}, err
	}

	row := core.DB.QueryRow("SELECT is_verified FROM Users WHERE id=$1", user)

	var isActive bool
	err = row.Scan(&isActive)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Error while getting user info from database",
			"user", user,
			"error", err,
		)
		return uuid.UUID{}, err
	}

	if isActive {
		return user, nil
	} else {
		return user, &UserExtractionError{}
	}
}
