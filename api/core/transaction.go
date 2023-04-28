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

// Message type of a transaction.
const (
	TransactionMessageType uint8 = 0x01
	BKVCMessageType        uint8 = 0x02
	TVCMessageType         uint8 = 0x03
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
	copy(data[1:17], b.UserID[:])
	binary.BigEndian.PutUint32(data[17:21], math.Float32bits(b.AvailableBalance))
	copy(data[21:53], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[53:57], uint32(b.TimeStamp.Unix()))

	sig := b.Signature[:]

	var pubKeyBytes []byte
	staticPublicKey := Configs.PUBLIC_KEY()
	copy(pubKeyBytes, staticPublicKey[:])

	if ed25519.Verify(staticPublicKey[:], data, sig) {
		l.Infow("BKVC verified")
		return true
	} else {
		l.Errorw("BKVC verification failed")
		return false
	}
}

type TransactionVerificationCertificate struct {
	MessageType          uint8
	TransactionSignature [64]byte
	TransactionID        uuid.UUID
	BKVC                 BalanceKeyVerificationCertificate
	Signature            [64]byte
}

// TVCFromBytes converts the byte slice into a TVC.
func TVCFromBytes(c *gin.Context, data []byte) (TransactionVerificationCertificate, error) {
	_, span := Tracer.Start(c.Request.Context(), "TVCFromBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	t := TransactionVerificationCertificate{}

	t.MessageType = TVCMessageType

	copy(t.TransactionSignature[:], data[1:65])

	var err error
	t.TransactionID, err = uuid.FromBytes(data[65:81])

	if err != nil {
		l.Errorw("Failed to convert byte slice into a TVC",
			"error", err,
		)
		return t, err
	}

	t.BKVC, err = BKVCFromBytes(c, data[81:202])

	if err != nil {
		l.Errorw("Failed to convert byte slice into a TVC",
			"error", err,
		)
		return t, err
	}

	copy(t.Signature[:], data[202:266])

	return t, nil
}

// ToBytes converts the TVC into a byte slice.
func (t *TransactionVerificationCertificate) ToBytes(c *gin.Context) []byte {
	_, span := Tracer.Start(c.Request.Context(), "TransactionVerificationCertificate.ToBytes()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 266)
	data[0] = TVCMessageType
	copy(data[1:65], t.TransactionSignature[:])
	copy(data[65:81], t.TransactionID[:])
	copy(data[81:202], t.BKVC.ToBytes(c))
	copy(data[202:266], t.Signature[:])

	l.Infow("TVC converted to bytes")

	return data
}

// Signs the TVC with the server private key.
func (t *TransactionVerificationCertificate) Sign(c *gin.Context) {
	_, span := Tracer.Start(c.Request.Context(), "Sign()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 202)
	data[0] = TVCMessageType
	copy(data[1:65], t.TransactionSignature[:])
	copy(data[65:81], t.TransactionID[:])
	copy(data[81:202], t.BKVC.ToBytes(c))

	sig := ed25519.Sign(Configs.PRIVATE_KEY(), data)
	copy(t.Signature[:], sig)

	l.Infow("TVC signed")
}

// Verify verifies the signature of the TVC.
func (t *TransactionVerificationCertificate) Verify(c *gin.Context) bool {
	_, span := Tracer.Start(c.Request.Context(), "TransactionVerificationCertificate.Verify()")
	defer span.End()
	l := Logger(c).Sugar()

	data := make([]byte, 202)
	data[0] = TVCMessageType
	copy(data[1:65], t.TransactionSignature[:])
	copy(data[65:81], t.TransactionID[:])
	copy(data[81:202], t.BKVC.ToBytes(c))

	sig := t.Signature[:]

	var pubKeyBytes []byte
	staticPublicKey := Configs.PUBLIC_KEY()
	copy(pubKeyBytes, staticPublicKey[:])

	if ed25519.Verify(staticPublicKey[:], data, sig) {
		l.Infow("TVC verified")
		return true
	} else {
		l.Errorw("TVC verification failed")
		return false
	}
}
