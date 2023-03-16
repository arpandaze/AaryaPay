package core

import (
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func GenerateSessionToken(c *gin.Context, userID uuid.UUID, expiry int) uuid.UUID {
	_, span := Tracer.Start(c.Request.Context(), "GenerateSessionToken()")
	defer span.End()

	token := uuid.New()

	duration := time.Duration(expiry * int(time.Second))

	key := fmt.Sprint("session_", token.String())

	status := Redis.SetEx(c, key, userID.String(), duration)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to set session token!",
			"userID", userID.String(),
			"error", err,
		)

		panic(err)
	}

	return token
}

func GetUserFromSession(c *gin.Context, token uuid.UUID) (uuid.UUID, error) {
	_, span := Tracer.Start(c.Request.Context(), "GetUserFromSession()")
	defer span.End()

	key := fmt.Sprint("session_", token.String())

	status := Redis.Get(c, key)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to get session details!",
			"error", err,
		)

		return uuid.UUID{}, err
	}

	idFromRedis, err := uuid.Parse(status.Val())

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to parse uuid received from Redis!",
			"error", err,
			"uuid", idFromRedis,
		)

		return uuid.UUID{}, err
	}

	return idFromRedis, nil
}

func GenerateResetToken(c *gin.Context, userID uuid.UUID) uuid.UUID {
	_, span := Tracer.Start(c.Request.Context(), "GenerateResetToken()")
	defer span.End()

	token := uuid.New()

	duration := time.Duration(Configs.SESSION_EXPIRE_TIME * int(time.Second))

	key := fmt.Sprint("reset_", token.String())

	status := Redis.SetEx(c, key, userID.String(), duration)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to set password reset token!",
			"userID", userID.String(),
			"error", err,
		)

		panic(err)
	}

	return token
}

func GetUserFromResetToken(c *gin.Context, token uuid.UUID) (uuid.UUID, error) {
	_, span := Tracer.Start(c.Request.Context(), "GetUserFromResetToken()")
	defer span.End()

	key := fmt.Sprint("reset_", token.String())

	status := Redis.Get(c, key)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to get user from reset token!",
			"error", err,
		)

		return uuid.UUID{}, err
	}

	idFromRedis, err := uuid.Parse(status.Val())

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to parse uuid received from Redis!",
			"error", err,
			"uuid", idFromRedis,
		)

		return uuid.UUID{}, err
	}

	return idFromRedis, nil
}

func GenerateVerificationToken(c *gin.Context, userID uuid.UUID) uuid.UUID {
	_, span := Tracer.Start(c.Request.Context(), "GenerateVerificationToken()")
	defer span.End()

	token := uuid.New()

	duration := time.Duration(Configs.SESSION_EXPIRE_TIME * int(time.Second))

	key := fmt.Sprint("verification_", token.String())

	status := Redis.SetEx(c, key, userID.String(), duration)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to set verification token!",
			"userID", userID.String(),
			"error", err,
		)

		panic(err)
	}

	return token
}

func GetUserFromVerificationToken(c *gin.Context, token uuid.UUID) (uuid.UUID, error) {
	_, span := Tracer.Start(c.Request.Context(), "GetUserFromVerificationToken()")
	defer span.End()

	key := fmt.Sprint("verification_", token.String())

	status := Redis.Get(c, key)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to get user from verification token!",
			"error", err,
		)

		return uuid.UUID{}, err
	}

	idFromRedis, err := uuid.Parse(status.Val())

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to parse uuid received from Redis!",
			"error", err,
			"uuid", idFromRedis,
		)
		panic(err)
	}

	return idFromRedis, nil
}
