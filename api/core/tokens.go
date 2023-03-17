package core

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func generateVerificationCode() (string, error) {
	const numDigits = 6
	max := big.NewInt(0).Exp(big.NewInt(10), big.NewInt(numDigits), nil)
	randomNum, err := rand.Int(rand.Reader, max)
	if err != nil {
		return "", err
	}
	code := randomNum.String()
	// Pad the code with leading zeros if necessary
	for len(code) < numDigits {
		code = "0" + code
	}
	return code, nil
}

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

func GenerateResetToken(c *gin.Context, userID uuid.UUID) string {
	_, span := Tracer.Start(c.Request.Context(), "GenerateResetToken()")
	defer span.End()

	token, err := generateVerificationCode()

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to generate verification code!",
			"error", err,
		)
		panic(err)
	}

	duration := time.Duration(Configs.SESSION_EXPIRE_TIME * int(time.Second))

	key := fmt.Sprint("reset_", userID.String())

	status := Redis.SetEx(c, key, token, duration)

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

func GenerateVerificationToken(c *gin.Context, userID uuid.UUID) string {
	_, span := Tracer.Start(c.Request.Context(), "GenerateVerificationToken()")
	defer span.End()

	token, err := generateVerificationCode()

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to generate verification code!",
			"error", err,
		)
		panic(err)
	}

	duration := time.Duration(Configs.SESSION_EXPIRE_TIME * int(time.Second))

	key := fmt.Sprint("verification_", userID.String())

	status := Redis.SetEx(c, key, token, duration)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to set verification token!",
			"userID", userID.String(),
			"error", err,
		)

		panic(err)
	}

	return token
}

func VerifyVerificationToken(c *gin.Context, userID uuid.UUID, token int) bool {
	_, span := Tracer.Start(c.Request.Context(), "GetUserFromVerificationToken()")
	defer span.End()

	key := fmt.Sprint("verification_", userID.String())

	status := Redis.Get(c, key)

	if err := status.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to get verification token from key!",
			"error", err,
		)

		return false
	}

	tokenRedis, err := strconv.Atoi(status.Val())

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to parse redis returned value into int",
			"error", err,
		)
		panic(err)
	}

	if token != tokenRedis {
		Logger(c).Sugar().Errorw("Verification token didn't match!",
			"user_id", userID.String())
		return false
	}

	delStatus := Redis.Del(c, key)

	if err := delStatus.Err(); err != nil {
		Logger(c).Sugar().Errorw("Failed to remote verification token from Redis!",
			"error", err,
		)
	}

	return true
}
