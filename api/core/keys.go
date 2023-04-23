package core

import (
	"crypto/ed25519"
	"database/sql"
	"encoding/base64"
	. "main/telemetry"
	"main/utils"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func GenerateKeyPair(c *gin.Context, userID uuid.UUID) ([]byte, []byte, time.Time, error) {
	_, span := Tracer.Start(c.Request.Context(), "GenerateKeyPair()")
	defer span.End()

	pubKey, fullKey, err := ed25519.GenerateKey(nil)

	if err != nil {
		Logger(c).Sugar().Errorw("Error generating key pair",
			"error", err,
		)
		return nil, nil, time.Time{}, err
	}

	// Make the previous active key inactive
	if _, err := DB.Exec(`
		UPDATE keys SET active = false WHERE associated_user = $1 AND active = true
	`, userID); err != nil {
		Logger(c).Sugar().Errorw("Failed to update active key",
			"error", err,
		)
		return nil, nil, time.Time{}, err
	}

	// Convert keys to base64-encoded strings
	fullKeyStr := base64.StdEncoding.EncodeToString(fullKey)

	// Insert key pair into the keys table
	var lastRefreshedAt time.Time
	err = DB.QueryRow(`
    INSERT INTO keys (value, active, associated_user)
    VALUES ($1, true, $2)
    RETURNING last_refreshed_at
`, fullKeyStr, userID).Scan(&lastRefreshedAt)

	if err != nil {
		Logger(c).Sugar().Errorw("Error inserting key pair into keys table",
			"error", err,
		)
		return nil, nil, time.Time{}, err
	}

	lastRefreshedAtBytes := utils.Int32ToByteArray(int32(lastRefreshedAt.Unix()))

	userIdByte, _ := userID.MarshalBinary()

	mergedPayload := utils.MergeByteArray(pubKey, lastRefreshedAtBytes)

	mergedPayload = utils.MergeByteArray(mergedPayload, userIdByte)

	return pubKey, fullKey, lastRefreshedAt, nil
}

func GetUserKey(c *gin.Context, userID uuid.UUID) ([]byte, time.Time, error) {
	_, span := Tracer.Start(c.Request.Context(), "GetUserKey()")
	defer span.End()

	var key string
	var lastRefreshedAt time.Time
	err := DB.QueryRow(`
    SELECT value, last_refreshed_at FROM keys WHERE associated_user = $1 AND active = true
  `, userID).Scan(&key, &lastRefreshedAt)

	if err != nil && err != sql.ErrNoRows {
		Logger(c).Sugar().Errorw("Error getting user key",
			"error", err,
		)
		return nil, time.Time{}, err
	}

	keyBytes, err := base64.StdEncoding.DecodeString(key)
	if err != nil {
		Logger(c).Sugar().Errorw("Error decoding user key",
			"error", err,
		)
		return nil, time.Time{}, err
	}

	return keyBytes, lastRefreshedAt, nil
}
