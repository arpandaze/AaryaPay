package test_core

import (
	"crypto/ed25519"
	"encoding/base64"
	"main/core"
	. "main/tests/helpers"
	"testing"
	"time"

	"github.com/go-playground/assert/v2"
	"github.com/google/uuid"
)

func TestBKVC(t *testing.T) {
	_, c, _ := TestInit()

	pub, _, _ := ed25519.GenerateKey(nil)

	//Convert pub key to [32]byte
	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = core.BalanceKeyVerificationCertificate{
		MessageType:      core.BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,
		PublicKey:        pub32,
		TimeStamp:        time.Now(),
	}

	BKVC.Sign(c)

	assert.Equal(t, BKVC.Verify(c), true)
}

func TestBKVCRemake(t *testing.T) {
	_, c, _ := TestInit()

	pub, _, _ := ed25519.GenerateKey(nil)

	//Convert pub key to [32]byte
	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = core.BalanceKeyVerificationCertificate{
		MessageType:      core.BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,
		PublicKey:        pub32,
		TimeStamp:        time.Now(),
	}

	BKVC.Sign(c)
	assert.Equal(t, BKVC.Verify(c), true)

	base64BKVC := base64.StdEncoding.EncodeToString(BKVC.ToBytes(c))

	base64BKVCBytes, _ := base64.StdEncoding.DecodeString(base64BKVC)

	BKVCRebuilt, err := core.BKVCFromBytes(c, base64BKVCBytes)

	assert.Equal(t, err, nil)

	assert.Equal(t, BKVCRebuilt.Verify(c), true)
}

func TestTransaction(t *testing.T) {
	_, c, _ := TestInit()

	pub, priv, _ := ed25519.GenerateKey(nil)

	//Convert pub key to [32]byte
	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = core.BalanceKeyVerificationCertificate{
		MessageType:      core.BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,
		PublicKey:        pub32,
		TimeStamp:        time.Now(),
	}

	BKVC.Sign(c)
	assert.Equal(t, BKVC.Verify(c), true)

	var transaction = core.Transaction{
		Amount:    10.0,
		To:        uuid.New(),
		BKVC:      BKVC,
		TimeStamp: time.Now(),
	}

	transaction.Sign(c, priv)

	assert.Equal(t, transaction.Verify(c), true)
}

func TestTransactionRebuild(t *testing.T) {
	_, c, _ := TestInit()

	pub, priv, _ := ed25519.GenerateKey(nil)

	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = core.BalanceKeyVerificationCertificate{
		MessageType:      core.BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,

		PublicKey: pub32,
		TimeStamp: time.Now(),
	}

	BKVC.Sign(c)

	assert.Equal(t, BKVC.Verify(c), true)

	var transaction = core.Transaction{
		MessageType: core.TransactionMessageType,
		Amount:      10.0,
		To:          uuid.New(),
		BKVC:        BKVC,
		TimeStamp:   time.Now(),
	}

	transaction.Sign(c, priv)

	assert.Equal(t, transaction.Verify(c), true)

	transactionBytes := transaction.ToBytes(c)
	base64Transaction := base64.StdEncoding.EncodeToString(transactionBytes)

	base64TransactionBytes, _ := base64.StdEncoding.DecodeString(base64Transaction)

	transactionRebuilt, err := core.TransactionFromBytes(c, base64TransactionBytes)

	assert.Equal(t, err, nil)

	assert.Equal(t, transactionRebuilt.Verify(c), true)
	assert.Equal(t, transactionRebuilt.BKVC.Verify(c), true)
	return
}

func TestTVC(t *testing.T) {
	_, c, _ := TestInit()

	pub, priv, _ := ed25519.GenerateKey(nil)

	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = core.BalanceKeyVerificationCertificate{
		MessageType:      core.BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,
		PublicKey:        pub32,
		TimeStamp:        time.Now(),
	}
	BKVC.Sign(c)

	var transaction = core.Transaction{
		MessageType: core.TransactionMessageType,
		Amount:      10.0,
		To:          uuid.New(),
		BKVC:        BKVC,
		TimeStamp:   time.Now(),
	}

	transaction.Sign(c, priv)

	var tvc = core.TransactionVerificationCertificate{
		MessageType:          core.TVCMessageType,
		TransactionSignature: transaction.Signature,
		TransactionID:        uuid.New(),
		BKVC:                 BKVC,
	}

	tvc.Sign(c)
	assert.Equal(t, tvc.Verify(c), true)
	tvc.Verify(c)

	base64TVC := base64.StdEncoding.EncodeToString(tvc.ToBytes(c))

	base64TVCBytes, _ := base64.StdEncoding.DecodeString(base64TVC)

	tvcRebuilt, err := core.TVCFromBytes(c, base64TVCBytes)

	assert.Equal(t, err, nil)

	assert.Equal(t, tvcRebuilt.Verify(c), true)

	assert.Equal(t, tvcRebuilt.BKVC.Verify(c), true)
}
