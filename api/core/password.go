package core

import (
	"crypto/rand"
	"crypto/subtle"
	"encoding/base64"
	"fmt"
	"main/telemetry"
	"strings"

	"github.com/gin-gonic/gin"
	// "go.opentelemetry.io/otel/attribute"
	// oteltrace "go.opentelemetry.io/otel/trace"
	"golang.org/x/crypto/argon2"
)

func HashPassword(c *gin.Context, password string) (string, error) {
	_, span := telemetry.Tracer.Start(c.Request.Context(), "HashPassword")
	defer span.End()

	salt := make([]byte, Configs.ARGON_SALT_LENGTH)
	if _, err := rand.Read(salt); err != nil {
		telemetry.Logger(c).Error("Failed to generate random salt!")
		return "", err
	}

	hash := argon2.IDKey([]byte(password), salt, Configs.ARGON_ITERATIONS, Configs.ARGON_MEMORY, Configs.ARGON_PARALLELISM, Configs.ARGON_KEY_LENGTH)

	return fmt.Sprintf(
			"$argon2id$v=%d$m=%d,t=%d,p=%d$%s$%s",
			argon2.Version,
			Configs.ARGON_MEMORY,
			Configs.ARGON_TIME,
			Configs.ARGON_PARALLELISM,
			base64.RawStdEncoding.EncodeToString(salt),
			base64.RawStdEncoding.EncodeToString(hash),
		),
		nil
}

func VerifyPassword(c *gin.Context, password, hash string) (bool, error) {
	_, span := telemetry.Tracer.Start(c.Request.Context(), "VerifyPassword")
	defer span.End()
	hashParts := strings.Split(hash, "$")

	_, err := fmt.Sscanf(hashParts[3], "m=%d,t=%d,p=%d", &Configs.ARGON_MEMORY, &Configs.ARGON_TIME, &Configs.ARGON_PARALLELISM)
	if err != nil {
		telemetry.Logger(c).Error("Got malformed hashed password from the database!")
		return false, err
	}

	salt, err := base64.RawStdEncoding.DecodeString(hashParts[4])
	if err != nil {
		telemetry.Logger(c).Error("Failed to decode base64 password salt!")
		return false, err
	}

	decodedHash, err := base64.RawStdEncoding.DecodeString(hashParts[5])
	if err != nil {
		telemetry.Logger(c).Error("Failed to decode base64 password hash!")
		return false, err
	}

	hashToCompare := argon2.IDKey([]byte(password), salt, Configs.ARGON_ITERATIONS, Configs.ARGON_MEMORY, Configs.ARGON_PARALLELISM, Configs.ARGON_KEY_LENGTH)

	return subtle.ConstantTimeCompare(decodedHash, hashToCompare) == 1, nil
}
