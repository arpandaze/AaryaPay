package core

import (
	"database/sql"

	_ "github.com/lib/pq"
)

var DB *sql.DB

func ConnectDatabase() {
	var db, err = sql.Open("postgres", Configs.POSTGRES_DATABASE_URI(false))

	if err != nil {
		panic(err)
	}

	DB = db
}
