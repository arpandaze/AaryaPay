package core

import (
	"database/sql"
	"main/telemetry"

	_ "github.com/lib/pq"
)

var DB *sql.DB

func ConnectDatabase() {
	var db, err = sql.Open("postgres", Configs.POSTGRES_DATABASE_URI(false))

	if err != nil {
		telemetry.Logger(nil).Sugar().Panicw("Failed to connect to database!",
			"error", err,
			"uri", Configs.POSTGRES_DATABASE_URI(false),
		)
		panic(err)
	}

	_, err = db.Query("SELECT 1")

	if err != nil {
		telemetry.Logger(nil).Sugar().Panicw("Failed to connect to database!",
			"error", err,
			"uri", Configs.POSTGRES_DATABASE_URI(false),
		)
	}

	DB = db
}
