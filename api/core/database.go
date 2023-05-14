package core

import (
	"context"
	"main/telemetry"

	"github.com/jackc/pgx/v5/pgxpool"
)

var DB *pgxpool.Pool

func ConnectDatabase() {
	conn, err := pgxpool.New(context.Background(), Configs.POSTGRES_DATABASE_URI(false))

	if err != nil {
		telemetry.Logger(nil).Sugar().Panicw("Failed to connect to database!",
			"error", err,
			"uri", Configs.POSTGRES_DATABASE_URI(false),
		)
		panic(err)
	}

	_, err = conn.Query(context.Background(), "SELECT 1")

	if err != nil {
		telemetry.Logger(nil).Sugar().Panicw("Failed to connect to database!",
			"error", err,
			"uri", Configs.POSTGRES_DATABASE_URI(false),
		)
	}

	DB = conn
}
