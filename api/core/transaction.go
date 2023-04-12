package core

import (
	"crypto/ed25519"
	"encoding/binary"
	"fmt"
	"math"
	"time"

	"github.com/google/uuid"
)

type Transaction struct {
	Amount    float32
	To        uuid.UUID
	BKVC      BalanceKeyVerificationCertificate
	Signature [64]byte
}

func (t *Transaction) ToBytes() []byte {
	data := make([]byte, 204)
	binary.BigEndian.PutUint32(data[0:4], math.Float32bits(t.Amount))
	copy(data[4:20], t.To[:])
	copy(data[20:140], t.BKVC.ToBytes())
	copy(data[140:204], t.Signature[:])
	return data
}

func TransactionFromBytes(data []byte) (Transaction, error) {
	t := Transaction{}
	t.Amount = math.Float32frombits(binary.BigEndian.Uint32(data[0:4]))
	copy(t.To[:], data[4:20])

	var err error
	t.BKVC, err = BKVCFromBytes(data[20:140])

	if err != nil {
		return t, err
	}

	copy(t.Signature[:], data[140:204])

	return t, nil
}

func (t *Transaction) Sign(privateKey ed25519.PrivateKey) {
	data := make([]byte, 140)
	binary.BigEndian.PutUint32(data[0:4], math.Float32bits(t.Amount))
	copy(data[4:20], t.To[:])
	copy(data[20:140], t.BKVC.ToBytes())

	sig := ed25519.Sign(privateKey, data)
	copy(t.Signature[:], sig)
}

func (t *Transaction) Verify() bool {
	data := make([]byte, 140)
	binary.BigEndian.PutUint32(data[0:4], math.Float32bits(t.Amount))
	copy(data[4:20], t.To[:])
	copy(data[20:140], t.BKVC.ToBytes())

	return ed25519.Verify(t.BKVC.PublicKey[:], data, t.Signature[:])
}

type BalanceKeyVerificationCertificate struct {
	UserID           uuid.UUID
	AvailableBalance float32
	PublicKey        [32]byte
	TimeStamp        time.Time
	Signature        [64]byte
}

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
	fmt.Println(b.Signature)
	data := make([]byte, 56)
	binary.BigEndian.PutUint64(data[0:8], uint64(b.UserID.Time()))
	binary.BigEndian.PutUint64(data[8:16], uint64(b.UserID.ClockSequence()))
	binary.BigEndian.PutUint32(data[16:20], math.Float32bits(b.AvailableBalance))
	copy(data[20:52], b.PublicKey[:])
	binary.BigEndian.PutUint32(data[52:56], uint32(b.TimeStamp.Unix()))

	fmt.Println("data")
	fmt.Println(data)
	sig := b.Signature[:]

	fmt.Println()

	pubKey := b.PublicKey[:]

	genSig := ed25519.Sign(Configs.PRIVATE_KEY(), data)
	fmt.Println("Generated Signature: ", genSig)

	if ed25519.Verify(pubKey, data, sig) {
		return true
	} else {
		return false
	}
}
