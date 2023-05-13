package payloads

import (
	"crypto/ed25519"
	"encoding/binary"
	"errors"
	"main/core"
	. "main/telemetry"
	"math"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// TransactionAuthorizationMessage represents a verified transaction with amount, recipient UUID,
// BalanceKeyVerificationCertificate (BKVC), and signature.
type TransactionVerificationCertificate struct {
	MessageType uint8
	Amount      float32
	From        uuid.UUID
	BKVC        BalanceKeyVerificationCertificate
	TimeStamp   time.Time
	Signature   [64]byte
}

// ToBytes converts the tvc into a byte slice.
func (t *TransactionVerificationCertificate) ToBytes(c *gin.Context) []byte {
	_, span := Tracer.Start(c.Request.Context(), "TransactionVerificationCertificate.ToBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 210)
	data[0] = TVCMessageType
	binary.BigEndian.PutUint32(data[1:5], math.Float32bits(t.Amount))
	copy(data[5:21], t.From[:])
	copy(data[21:142], t.BKVC.ToBytes(c))
	binary.BigEndian.PutUint32(data[142:146], uint32(t.TimeStamp.Unix()))
	copy(data[146:210], t.Signature[:])

	l.Infow("Transaction converted to bytes")

	return data
}

// TransactionFromBytes converts the byte slice into a TVC.
func TVCFromBytes(c *gin.Context, data []byte) (TransactionVerificationCertificate, error) {
	_, span := Tracer.Start(c.Request.Context(), "TVCFromBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	if len(data) != 210 {
		l.Errorw("Invalid TVC length",
			"length", len(data),
		)
		return TransactionVerificationCertificate{}, errors.New("invalid TVC length")
	}

	t := TransactionVerificationCertificate{}
	t.MessageType = TVCMessageType
	t.Amount = math.Float32frombits(binary.BigEndian.Uint32(data[1:5]))
	copy(t.From[:], data[5:21])

	var err error
	t.BKVC, err = BKVCFromBytes(c, data[21:142])

	if err != nil {
		l.Errorw("Failed to convert byte slice into a TVC",
			"error", err,
		)
		return t, err
	}

	t.TimeStamp = time.Unix(int64(binary.BigEndian.Uint32(data[142:146])), 0)

	copy(t.Signature[:], data[146:210])

	return t, nil
}

// Sign signs the transaction with the given private key.
func (t *TransactionVerificationCertificate) Sign(c *gin.Context) {
	_, span := Tracer.Start(c.Request.Context(), "TransactionVerificationCertificate.Sign()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 146)
	data[0] = TVCMessageType
	binary.BigEndian.PutUint32(data[1:5], math.Float32bits(t.Amount))
	copy(data[5:21], t.From[:])
	copy(data[21:142], t.BKVC.ToBytes(c))
	binary.BigEndian.PutUint32(data[142:146], uint32(t.TimeStamp.Unix()))

	sig := ed25519.Sign(core.Configs.PRIVATE_KEY(), data)

	l.Infow("TVC signed")

	copy(t.Signature[:], sig)
}

// Verify verifies the signature of the transaction.
func (t *TransactionVerificationCertificate) Verify(c *gin.Context) bool {
	_, span := Tracer.Start(c.Request.Context(), "TransactionVerificationCertificate.Verify()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 146)
	data[0] = TVCMessageType
	binary.BigEndian.PutUint32(data[1:5], math.Float32bits(t.Amount))
	copy(data[5:21], t.From[:])
	copy(data[21:142], t.BKVC.ToBytes(c))
	binary.BigEndian.PutUint32(data[142:146], uint32(t.TimeStamp.Unix()))

	l.Infow("TVC verified")

	staticPublicKey := core.Configs.PUBLIC_KEY()

	return ed25519.Verify([]byte(staticPublicKey[:]), data, t.Signature[:])
}
