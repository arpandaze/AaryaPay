package core

import (
	"crypto/ed25519"
	"database/sql"
	"encoding/base64"
	"errors"
	"main/telemetry"
	. "main/telemetry"
	"main/utils"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type KeyPair struct {
	IsEmpty  bool
	rawbytes []byte
}

func KeyPairFromBytes(c *gin.Context, rawbytes []byte) (KeyPair, error) {
	_, span := Tracer.Start(c.Request.Context(), "KeyPairFromBytes()")
	defer span.End()

	if len(rawbytes) != 64 {
		Logger(c).Sugar().Errorw("Invalid key pair length",
			"length", len(rawbytes),
		)
		return KeyPair{}, errors.New("Invalid key pair length")
	}

	return KeyPair{false, rawbytes}, nil
}

func (kp *KeyPair) Bytes() []byte {
	return kp.rawbytes
}

func (kp *KeyPair) PrivateKey() []byte {
	return kp.rawbytes
}

func (kp *KeyPair) PublicKey() []byte {
	return kp.rawbytes[32:]
}

func (kp *KeyPair) PrivateHalf() []byte {
	return kp.rawbytes[:32]
}

func GenerateKeyPair(c *gin.Context, userID uuid.UUID) (KeyPair, time.Time, error) {
	_, span := Tracer.Start(c.Request.Context(), "GenerateKeyPair()")
	defer span.End()

	pubKey, fullKey, err := ed25519.GenerateKey(nil)

	if err != nil {
		Logger(c).Sugar().Errorw("Error generating key pair",
			"error", err,
		)
		return KeyPair{}, time.Time{}, err
	}

	// Make the previous active key inactive
	if _, err := DB.Exec(`
		UPDATE keys SET active = false WHERE associated_user = $1 AND active = true
	`, userID); err != nil {
		Logger(c).Sugar().Errorw("Failed to update active key",
			"error", err,
		)
		return KeyPair{}, time.Time{}, err
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
		return KeyPair{}, time.Time{}, err
	}

	lastRefreshedAtBytes := utils.Int32ToByteArray(int32(lastRefreshedAt.Unix()))

	userIdByte, _ := userID.MarshalBinary()

	mergedPayload := utils.MergeByteArray(pubKey, lastRefreshedAtBytes)

	mergedPayload = utils.MergeByteArray(mergedPayload, userIdByte)

	keyPair, err := KeyPairFromBytes(c, fullKey)

	return keyPair, lastRefreshedAt, nil
}

func GetUserKeyPair(c *gin.Context, userID uuid.UUID) (KeyPair, time.Time, error) {
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
		return KeyPair{true, []byte{}}, time.Time{}, err
	}

	if sql.ErrNoRows == err {
		Logger(c).Sugar().Errorw("No key found for user",
			"error", err,
		)
		return KeyPair{}, time.Time{}, nil
	}

	keyBytes, err := base64.StdEncoding.DecodeString(key)
	if err != nil {
		Logger(c).Sugar().Errorw("Error decoding user key",
			"error", err,
		)
		return KeyPair{}, time.Time{}, err
	}

	keyPair, err := KeyPairFromBytes(c, keyBytes)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Error creating key pair from bytes",
			"error", err,
		)
		return KeyPair{}, time.Time{}, err
	}

	return keyPair, lastRefreshedAt, nil
}
