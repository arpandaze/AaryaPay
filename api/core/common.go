package core

import (
	"database/sql"

	"github.com/google/uuid"
)

type CommonUser struct {
	Id         uuid.UUID     `db:"id"`
	FirstName  string        `db:"first_name"`
	MiddleName string        `db:"middle_name"`
	LastName   string        `db:"last_name"`
	Email      string        `db:"email"`
	IsVerified bool          `db:"is_verified"`
	LastSync   utils.UnixTimestamp `db:"pubkey_updated_at"`
}
