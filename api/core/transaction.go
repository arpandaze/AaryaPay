package core

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
	Amount    float32
	To        uuid.UUID
	BKVC      BalanceKeyVerificationCertificate
	Signature [64]byte
}

// ToBytes converts the transaction into a byte slice.
func (t *Transaction) ToBytes(c *gin.Context) []byte {
	_, span := Tracer.Start(c.Request.Context(), "Transaction.ToBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 204)
	binary.BigEndian.PutUint32(data[0:4], math.Float32bits(t.Amount))
	copy(data[4:20], t.To[:])
	copy(data[20:140], t.BKVC.ToBytes())
	copy(data[140:204], t.Signature[:])

	l.Infow("Transaction converted to bytes")

	return data
}

// TransactionFromBytes converts the byte slice into a Transaction.
func TransactionFromBytes(c *gin.Context, data []byte) (Transaction, error) {
	_, span := Tracer.Start(c.Request.Context(), "TransactionFromBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	t := Transaction{}
	t.Amount = math.Float32frombits(binary.BigEndian.Uint32(data[0:4]))
	copy(t.To[:], data[4:20])

	var err error
	t.BKVC, err = BKVCFromBytes(data[20:140])

	if err != nil {
		l.Errorw("Failed to convert byte slice into a transaction",
			"error", err,
		)
		return t, err
	}

	copy(t.Signature[:], data[140:204])

	return t, nil
}

// Sign signs the transaction with the given private key.
func (t *Transaction) Sign(c *gin.Context, privateKey ed25519.PrivateKey) {
	_, span := Tracer.Start(c.Request.Context(), "Transaction.Sign()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 140)
	binary.BigEndian.PutUint32(data[0:4], math.Float32bits(t.Amount))
	copy(data[4:20], t.To[:])
	copy(data[20:140], t.BKVC.ToBytes())

	sig := ed25519.Sign(privateKey, data)

	l.Infow("Transaction signed")

	copy(t.Signature[:], sig)
}

// Verify verifies the signature of the transaction.
func (t *Transaction) Verify() bool {
	data := make([]byte, 140)
	binary.BigEndian.PutUint32(data[0:4], math.Float32bits(t.Amount))
	copy(data[4:20], t.To[:])
	copy(data[20:140], t.BKVC.ToBytes())

	return ed25519.Verify(t.BKVC.PublicKey[:], data, t.Signature[:])
}

// BalanceKeyVerificationCertificate represents a BKVC with UserID,
// available balance, public key, timestamp, and signature.
type BalanceKeyVerificationCertificate struct {
	UserID           uuid.UUID
	AvailableBalance float32
	PublicKey        [32]byte
	TimeStamp        time.Time
	Signature        [64]byte
}

// BKVCFromBytes converts the byte slice into a BKVC.
func BKVCFromBytes(data []byte) (BalanceKeyVerificationCertificate, error) {

	b := BalanceKeyVerificationCertificate{}

	var err error
	b.UserID, err = uuid.FromBytes(data[0:16])

	if err != nil {
		return b, err
	}

	b.AvailableBalance = math.Float32frombits(binary.BigEndian.Uint32(data[16:20]))
	copy(b.PublicKey[:], data[20:52])

	b.TimeStamp = time.Unix(int64(binary.BigEndian.Uint32(data[52:56])), 0)
	copy(b.Signature[:], data[56:120])

	return b, nil
}

// ToBytes converts the BKVC into a byte slice.
func (b *BalanceKeyVerificationCertificate) ToBytes() []byte {
	data := make([]byte, 120)
	copy(data[0:16], b.UserID[:])
	binary.BigEndian.PutUint32(data[16:20], math.Float32bits(b.AvailableBalance))
	copy(data[20:52], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[52:56], uint32(b.TimeStamp.Unix()))
	copy(data[56:120], b.Signature[:])

	return data
}

func (b *BalanceKeyVerificationCertificate) Sign() {
	data := make([]byte, 56)
	binary.BigEndian.PutUint64(data[0:8], uint64(b.UserID.Time()))
	binary.BigEndian.PutUint64(data[8:16], uint64(b.UserID.ClockSequence()))
	binary.BigEndian.PutUint32(data[16:20], math.Float32bits(b.AvailableBalance))
	copy(data[20:52], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[52:56], uint32(b.TimeStamp.Unix()))

	sig := ed25519.Sign(Configs.PRIVATE_KEY(), data)
	copy(b.Signature[:], sig)
}

func (b *BalanceKeyVerificationCertificate) Verify() bool {
	data := make([]byte, 56)
	binary.BigEndian.PutUint64(data[0:8], uint64(b.UserID.Time()))
	binary.BigEndian.PutUint64(data[8:16], uint64(b.UserID.ClockSequence()))
	binary.BigEndian.PutUint32(data[16:20], math.Float32bits(b.AvailableBalance))
	copy(data[20:52], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[52:56], uint32(b.TimeStamp.Unix()))

	sig := b.Signature[:]

	pubKey := b.PublicKey[:]

	if ed25519.Verify(pubKey, data, sig) {
		return true
	} else {
		return false
	}
}
