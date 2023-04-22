package test_core

import (
	"crypto/ed25519"
	"encoding/base64"
	"fmt"
	"main/core"
	. "main/tests/helpers"
	"testing"
	"time"

	"github.com/go-playground/assert/v2"
	"github.com/google/uuid"
)

func TestTransaction(t *testing.T) {
	_, c, _ := TestInit()

	pub, priv, _ := ed25519.GenerateKey(nil)

	//Convert pub key to [32]byte
	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = core.BalanceKeyVerificationCertificate{
		UserID:           uuid.New(),
		AvailableBalance: 100.0,

		PublicKey: pub32,
		TimeStamp: time.Now(),
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

	fmt.Println("Test Private Key:")
	fmt.Println(base64.StdEncoding.EncodeToString(priv))

	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = core.BalanceKeyVerificationCertificate{
		UserID:           uuid.New(),
		AvailableBalance: 100.0,

		PublicKey: pub32,
		TimeStamp: time.Now(),
	}

	BKVC.Sign(c)

	fmt.Println("Test BKVC:")
	fmt.Println(base64.StdEncoding.EncodeToString(BKVC.ToBytes(c)))

	assert.Equal(t, BKVC.Verify(c), true)

	var transaction = core.Transaction{
		Amount:    10.0,
		To:        uuid.New(),
		BKVC:      BKVC,
		TimeStamp: time.Now(),
	}

	fmt.Println("trans")
	transaction.Sign(c, priv)
	fmt.Println(transaction.ToBytes(c))

	fmt.Println("Test Transaction:")
	fmt.Println(base64.StdEncoding.EncodeToString(transaction.ToBytes(c)))

	assert.Equal(t, transaction.Verify(c), true)

	transactionBytes := transaction.ToBytes(c)
	base64Transaction := base64.StdEncoding.EncodeToString(transactionBytes)

	base64TransactionBytes, _ := base64.StdEncoding.DecodeString(base64Transaction)
	transactionRebuilt, err := core.TransactionFromBytes(c, base64TransactionBytes)

	assert.Equal(t, err, nil)

	assert.Equal(t, transactionRebuilt.Verify(c), true)
	assert.Equal(t, transactionRebuilt.BKVC.Verify(c), true)
	assert.Equal(t, transactionRebuilt, transaction)
}
