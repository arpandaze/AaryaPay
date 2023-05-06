package payloads

import (
	"crypto/ed25519"
	"encoding/binary"
	. "main/telemetry"
	"math"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// Transaction represents a transaction with amount, recipient UUID,
// BalanceKeyVerificationCertificate (BKVC), and signature.
type Transaction struct {
	MessageType uint8
	Amount      float32
	To          uuid.UUID
	BKVC        BalanceKeyVerificationCertificate
	TimeStamp   time.Time
	Signature   [64]byte
}

// ToBytes converts the transaction into a byte slice.
func (t *Transaction) ToBytes(c *gin.Context) []byte {
	_, span := Tracer.Start(c.Request.Context(), "Transaction.ToBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 210)
	data[0] = TransactionMessageType
	binary.BigEndian.PutUint32(data[1:5], math.Float32bits(t.Amount))
	copy(data[5:21], t.To[:])
	copy(data[21:142], t.BKVC.ToBytes(c))
	binary.BigEndian.PutUint32(data[142:146], uint32(t.TimeStamp.Unix()))
	copy(data[146:210], t.Signature[:])

	l.Infow("Transaction converted to bytes")

	return data
}

// TransactionFromBytes converts the byte slice into a Transaction.
func TransactionFromBytes(c *gin.Context, data []byte) (Transaction, error) {
	_, span := Tracer.Start(c.Request.Context(), "TransactionFromBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	t := Transaction{}
	t.MessageType = TransactionMessageType
	t.Amount = math.Float32frombits(binary.BigEndian.Uint32(data[1:5]))
	copy(t.To[:], data[5:21])

	var err error
	t.BKVC, err = BKVCFromBytes(c, data[21:142])

	if err != nil {
		l.Errorw("Failed to convert byte slice into a transaction",
			"error", err,
		)
		return t, err
	}

	t.TimeStamp = time.Unix(int64(binary.BigEndian.Uint32(data[142:146])), 0)

	copy(t.Signature[:], data[146:210])

	return t, nil
}

// Sign signs the transaction with the given private key.
func (t *Transaction) Sign(c *gin.Context, privateKey ed25519.PrivateKey) {
	_, span := Tracer.Start(c.Request.Context(), "Transaction.Sign()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 146)
	data[0] = TransactionMessageType
	binary.BigEndian.PutUint32(data[1:5], math.Float32bits(t.Amount))
	copy(data[5:21], t.To[:])
	copy(data[21:142], t.BKVC.ToBytes(c))
	binary.BigEndian.PutUint32(data[142:146], uint32(t.TimeStamp.Unix()))

	sig := ed25519.Sign(privateKey, data)

	l.Infow("Transaction signed")

	copy(t.Signature[:], sig)
}

// Verify verifies the signature of the transaction.
func (t *Transaction) Verify(c *gin.Context) bool {
	_, span := Tracer.Start(c.Request.Context(), "Transaction.Verify()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 146)
	data[0] = TransactionMessageType
	binary.BigEndian.PutUint32(data[1:5], math.Float32bits(t.Amount))
	copy(data[5:21], t.To[:])
	copy(data[21:142], t.BKVC.ToBytes(c))
	binary.BigEndian.PutUint32(data[142:146], uint32(t.TimeStamp.Unix()))

	l.Infow("Transaction verified")

	return ed25519.Verify(t.BKVC.PublicKey[:], data, t.Signature[:])
}
