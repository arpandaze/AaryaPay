package core

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

var DB *sql.DB

func ConnectDatabase() {
  fmt.Println(Configs.POSTGRES_DATABASE_URI(false))
	var db, err = sql.Open("postgres", Configs.POSTGRES_DATABASE_URI(false))

	if err != nil {
		panic(err)
	}

	DB = db
}
