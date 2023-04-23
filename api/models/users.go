package models

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"main/core"
	. "main/telemetry"
	"time"
)

// CREATE TABLE Users (
//     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
//     photo_url VARCHAR(255),
//     first_name VARCHAR(50) NOT NULL,
//     middle_name VARCHAR(50),
//     last_name VARCHAR(50) NOT NULL,
//     dob DATE NOT NULL,
//     password VARCHAR(255) NOT NULL,
//     email VARCHAR(255) NOT NULL UNIQUE,
//     is_verified BOOLEAN DEFAULT false NOT NULL,
//     two_factor_auth VARCHAR(255),
//     last_sync TIMESTAMP,
//     created_at TIMESTAMP DEFAULT NOW()
// );

type User struct {
	Id              *string    `json:"id"`
	PhotoURL        *string    `json:"photo_url"`
	FirstName       *string    `json:"first_name"`
	MiddleName      *string    `json:"middle_name"`
	LastName        *string    `json:"last_name"`
	DOB             *time.Time `json:"dob"`
	Password        *string    `json:"password"`
	Email           *string    `json:"email"`
	IsVerified      *bool      `json:"is_verified"`
	TwoFactorAuth   *string    `json:"two_factor_auth"`
	LastSync        *time.Time `json:"last_sync"`
	CreatedAt       *time.Time `json:"created_at"`
	PubKeyUpdatedAt *time.Time `json:"pubkey_updated_at"`
}

func GetUserByID(c *gin.Context, userID uuid.UUID) (User, error) {
	_, span := Tracer.Start(c.Request.Context(), "()")
	defer span.End()
	l := Logger(c).Sugar()

	var user User

	err := core.DB.QueryRow("SELECT id, photo_url, first_name, middle_name, last_name, dob, email FROM Users WHERE id = $1", userID).Scan(
		&user.Id,
		&user.PhotoURL,
		&user.FirstName,
		&user.MiddleName,
		&user.LastName,
		&user.DOB,
		&user.Email,
	)

	if err != nil {
		l.Errorw("Failed to get user by ID!",
			"error", err,
		)
		return User{}, err
	}

	return user, nil
}
