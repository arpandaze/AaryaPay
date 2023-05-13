package payloads

import (
	"crypto/ed25519"
	"encoding/binary"
	"errors"
	. "main/core"
	. "main/telemetry"
	"math"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// BalanceKeyVerificationCertificate represents a BKVC with UserID,
// available balance, public key, timestamp, and signature.
type BalanceKeyVerificationCertificate struct {
	MessageType      uint8
	UserID           uuid.UUID
	AvailableBalance float32
	PublicKey        [32]byte
	TimeStamp        time.Time
	Signature        [64]byte
}

// BKVCFromBytes converts the byte slice into a BKVC.
func BKVCFromBytes(c *gin.Context, data []byte) (BalanceKeyVerificationCertificate, error) {
	_, span := Tracer.Start(c.Request.Context(), "BKVCFromBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	if len(data) != 121 {
		l.Errorw("Invalid TAM length",
			"length", len(data),
		)
		return BalanceKeyVerificationCertificate{}, errors.New("invalid TAM length")
	}

	b := BalanceKeyVerificationCertificate{}

	b.MessageType = BKVCMessageType

	var err error
	b.UserID, err = uuid.FromBytes(data[1:17])

	if err != nil {
		l.Errorw("Failed to convert byte slice into a BKVC",
			"error", err,
		)
		return b, err
	}

	b.AvailableBalance = math.Float32frombits(binary.BigEndian.Uint32(data[17:21]))
	copy(b.PublicKey[:], data[21:53])

	b.TimeStamp = time.Unix(int64(binary.BigEndian.Uint32(data[53:57])), 0)
	copy(b.Signature[:], data[57:121])

	return b, nil
}

// ToBytes converts the BKVC into a byte slice.
func (b *BalanceKeyVerificationCertificate) ToBytes(c *gin.Context) []byte {
	_, span := Tracer.Start(c.Request.Context(), "BalanceKeyVerificationCertificate.ToBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 121)
	data[0] = BKVCMessageType
	copy(data[1:17], b.UserID[:])
	binary.BigEndian.PutUint32(data[17:21], math.Float32bits(b.AvailableBalance))
	copy(data[21:53], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[53:57], uint32(b.TimeStamp.Unix()))
	copy(data[57:121], b.Signature[:])

	l.Infow("BKVC converted to bytes")

	return data
}

// Signs the BKVC with the server private key.
func (b *BalanceKeyVerificationCertificate) Sign(c *gin.Context) {
	_, span := Tracer.Start(c.Request.Context(), "Sign()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 57)
	data[0] = BKVCMessageType
	copy(data[1:17], b.UserID[:])
	binary.BigEndian.PutUint32(data[17:21], math.Float32bits(b.AvailableBalance))
	copy(data[21:53], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[53:57], uint32(b.TimeStamp.Unix()))

	sig := ed25519.Sign(Configs.PRIVATE_KEY(), data)
	copy(b.Signature[:], sig)

	l.Infow("BKVC signed")
}

// Verify verifies the signature of the BKVC.
func (b *BalanceKeyVerificationCertificate) Verify(c *gin.Context) bool {
	_, span := Tracer.Start(c.Request.Context(), "BalanceKeyVerificationCertificate.Verify()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 57)
	data[0] = BKVCMessageType
	copy(data[1:17], b.UserID[:])
	binary.BigEndian.PutUint32(data[17:21], math.Float32bits(b.AvailableBalance))
	copy(data[21:53], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[53:57], uint32(b.TimeStamp.Unix()))

	sig := b.Signature[:]

	staticPublicKey := Configs.PUBLIC_KEY()

	if ed25519.Verify([]byte(staticPublicKey[:]), data, sig) {
		l.Infow("BKVC verified")
		return true
	} else {
		l.Errorw("BKVC verification failed")
		return false
	}
}
