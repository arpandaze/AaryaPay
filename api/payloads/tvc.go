package payloads

import (
	"crypto/ed25519"
	. "main/telemetry"
	. "main/core"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

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
