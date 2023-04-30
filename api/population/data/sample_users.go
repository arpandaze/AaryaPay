package data

import (
	"log"
	"main/core"
	"time"

	"github.com/google/uuid"
)

type SampleUser struct {
	id              uuid.UUID
	first_name      string
	middle_name     string
	last_name       string
	dob             time.Time
	password        string
	email           string
	is_verified     bool
	two_factor_auth string
}

var SAMPLE_USERS = []SampleUser{
	{
		first_name:  "Arpan",
		middle_name: "",
		last_name:   "Koirala",
		dob:         time.Date(2001, 8, 1, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "daze@test.com",
		is_verified: true,
	},
	{
		first_name:  "Aatish",
		middle_name: "",
		last_name:   "Shrestha",
		dob:         time.Date(2001, 8, 1, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "aatish.stha@test.com",
		is_verified: true,
	},
	{
		first_name:  "John",
		middle_name: "Paul",
		last_name:   "Doe",
		dob:         time.Date(1990, 1, 1, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "josh.paul@test.com",
		is_verified: true,
	},
	{
		first_name:  "Alice",
		middle_name: "",
		last_name:   "Smith",
		dob:         time.Date(1995, 5, 10, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "alice@test.com",
		is_verified: true,
	},
	{
		first_name:  "Bob",
		middle_name: "",
		last_name:   "Johnson",
		dob:         time.Date(1985, 11, 30, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "bob@test.com",
		is_verified: true,
	},
	{
		first_name:  "Charlie",
		middle_name: "",
		last_name:   "Brown",
		dob:         time.Date(1999, 4, 15, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "charlie@test.com",
		is_verified: true,
	},
	{
		first_name:  "David",
		middle_name: "",
		last_name:   "Lee",
		dob:         time.Date(1980, 8, 22, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "david@test.com",
		is_verified: true,
	},
	{
		first_name:  "Emily",
		middle_name: "",
		last_name:   "Nguyen",
		dob:         time.Date(1997, 2, 28, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "emily@test.com",
		is_verified: true,
	},
	{
		first_name:  "Frank",
		middle_name: "",
		last_name:   "Kim",
		dob:         time.Date(1993, 7, 12, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "frank@test.com",
		is_verified: true,
	},
	{
		first_name:  "Grace",
		middle_name: "",
		last_name:   "Wong",
		dob:         time.Date(1989, 12, 8, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "grace@test.com",
		is_verified: true,
	},
	{
		first_name:  "Henry",
		middle_name: "",
		last_name:   "Chen",
		dob:         time.Date(1992, 6, 18, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "henry@test.com",
		is_verified: true,
	},
	{
		first_name:  "Isabella",
		middle_name: "",
		last_name:   "Garcia",
		dob:         time.Date(1998, 10, 20, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "isabella@test.com",
		is_verified: true,
	},
	{
		first_name:  "Jake",
		middle_name: "",
		last_name:   "Davis",
		dob:         time.Date(1991, 3, 4, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "jake@test.com",
		is_verified: true,
	},
	{
		first_name:  "Kelly",
		middle_name: "",
		last_name:   "Liu",
		dob:         time.Date(1987, 9, 27, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "kelly@test.com",
		is_verified: true,
	},
	{
		first_name:  "Leo",
		middle_name: "",
		last_name:   "Gupta",
		dob:         time.Date(1996, 1, 15, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "leo@test.com",
		is_verified: true,
	},
	{
		first_name:  "Mia",
		middle_name: "",
		last_name:   "Choi",
		dob:         time.Date(1994, 8, 6, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "mia@test.com",
		is_verified: true,
	},
	{
		first_name:  "Nick",
		middle_name: "",
		last_name:   "Patel",
		dob:         time.Date(1993, 12, 22, 0, 0, 0, 0, time.UTC),
		password:    "$argon2id$v=19$m=65536,t=1,p=2$MwriWsH6H3EPGCc6E3s0QA$x4uW44k1pw1VeoIlh9VjrTZzn4hvXa/9MNXViEpTH44",
		email:       "nick@test.com",
		is_verified: true,
	},
}

func PopulateUsers() {
	for idx := range SAMPLE_USERS {
		user := &SAMPLE_USERS[idx]

		tx, err := core.DB.Begin()
		if err != nil {
			msg := "Failed to start transaction"
			log.Fatal(err)
			log.Fatal(msg)
			return
		}

		query := `
    INSERT INTO Users
    (
        first_name,
        middle_name,
        last_name,
        dob,
        password,
        email,
        is_verified,
        two_factor_auth
    )
    VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8
    )
    RETURNING id;
`

		err = tx.
			QueryRow(query, user.first_name, user.middle_name, user.last_name, user.dob, user.password, user.email, user.is_verified, user.two_factor_auth).
			Scan(&user.id)

		if err != nil {
			msg := "Failed to execute SQL statement"
			log.Printf(msg)
			log.Fatal(err)
			tx.Rollback()
			return
		}

		accountsCreateQuery := "INSERT INTO Accounts (id, balance) VALUES ($1, $2)"

		_, err = tx.Exec(accountsCreateQuery, user.id, 0)

		if err != nil {
			msg := "Failed to execute account insert statement"
			log.Printf(msg)
			log.Fatal(err)
			tx.Rollback()
			return
		}

		// Commit the transaction if both statements succeeded
		err = tx.Commit()
		if err != nil {
			log.Fatal(err)
			tx.Rollback()
			return
		}
		log.Printf("User and account for %s %s created", user.first_name, user.last_name)
	}
}
