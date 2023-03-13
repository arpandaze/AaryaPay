package core

type CommonUser struct {
	FirstName  string `db:"first_name"`
	MiddleName string `db:"middle_name"`
	LastName   string `db:"last_name"`
	Email string `db:"email"`
	PubKeyUpdatedAt string `db:"pubkey_updated_at"`
}
