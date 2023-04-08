package core

import (
	"context"
	"fmt"
	"main/telemetry"

	"github.com/redis/go-redis/v9"
)

var ctx = context.Background()

var Redis *redis.Client

func ConnectRedis() {
	Redis = redis.NewClient(&redis.Options{
		Addr:     fmt.Sprint(Configs.REDIS_SERVER, ":", Configs.REDIS_PORT),
		Username: Configs.REDIS_USER,
		Password: Configs.REDIS_PASSWORD,
		DB:       0,
	})

	err := Redis.Ping(ctx).Err()
	if err != nil {
		telemetry.Logger(nil).Fatal("Failed to connect to Redis!")
		panic(err)
	}
}
