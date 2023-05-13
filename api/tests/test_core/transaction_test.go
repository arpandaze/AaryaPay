package test_core

import (
	"crypto/ed25519"
	"encoding/base64"
	"fmt"
	. "main/payloads"
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

	var BKVC = BalanceKeyVerificationCertificate{
		MessageType:      BKVCMessageType,
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

	var BKVC = BalanceKeyVerificationCertificate{
		MessageType:      BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,
		PublicKey:        pub32,
		TimeStamp:        time.Now(),
	}

	BKVC.Sign(c)
	assert.Equal(t, BKVC.Verify(c), true)

	base64BKVC := base64.StdEncoding.EncodeToString(BKVC.ToBytes(c))

	base64BKVCBytes, _ := base64.StdEncoding.DecodeString(base64BKVC)

	BKVCRebuilt, err := BKVCFromBytes(c, base64BKVCBytes)

	assert.Equal(t, err, nil)

	assert.Equal(t, BKVCRebuilt.Verify(c), true)
}

func TestTransaction(t *testing.T) {
	_, c, _ := TestInit()

	pub, priv, _ := ed25519.GenerateKey(nil)

	//Convert pub key to [32]byte
	var pub32 [32]byte
	copy(pub32[:], pub[:])

	var BKVC = BalanceKeyVerificationCertificate{
		MessageType:      BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,
		PublicKey:        pub32,
		TimeStamp:        time.Now(),
	}

	BKVC.Sign(c)
	assert.Equal(t, BKVC.Verify(c), true)

	var transaction = TransactionAuthorizationMessage{
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

	var BKVC = BalanceKeyVerificationCertificate{
		MessageType:      BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,

		PublicKey: pub32,
		TimeStamp: time.Now(),
	}

	BKVC.Sign(c)

	assert.Equal(t, BKVC.Verify(c), true)

	var transaction = TransactionAuthorizationMessage{
		MessageType: TAMMessageType,
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

	transactionRebuilt, err := TAMFromBytes(c, base64TransactionBytes)

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

	fmt.Println("privKey: ", base64.StdEncoding.EncodeToString(priv))
	fmt.Println("pubKey: ", base64.StdEncoding.EncodeToString(pub))

	var BKVC = BalanceKeyVerificationCertificate{
		MessageType:      BKVCMessageType,
		UserID:           uuid.New(),
		AvailableBalance: 100.0,
		PublicKey:        pub32,
		TimeStamp:        time.Now(),
	}
	BKVC.Sign(c)

	fmt.Println("BKVC: ", base64.StdEncoding.EncodeToString(BKVC.ToBytes(c)))

	var transaction = TransactionAuthorizationMessage{
		MessageType: TAMMessageType,
		Amount:      10.0,
		To:          uuid.New(),
		BKVC:        BKVC,
		TimeStamp:   time.Now(),
	}

	transaction.Sign(c, priv)

	fmt.Println("TAM: ", base64.StdEncoding.EncodeToString(transaction.ToBytes(c)))

	var tvc = TransactionVerificationCertificate{
		MessageType: TVCMessageType,
		Amount:      transaction.Amount,
		From:        uuid.New(),
		TimeStamp:   time.Now(),
		BKVC:        BKVC,
	}

	tvc.Sign(c)
	tvc.Verify(c)

	fmt.Println("TVC: ", base64.StdEncoding.EncodeToString(tvc.ToBytes(c)))
	// assert.Equal(t, tvc.Verify(c), true)

	base64TVC := base64.StdEncoding.EncodeToString(tvc.ToBytes(c))

	base64TVCBytes, _ := base64.StdEncoding.DecodeString(base64TVC)

	tvcRebuilt, err := TVCFromBytes(c, base64TVCBytes)

	assert.Equal(t, err, nil)

	assert.Equal(t, tvcRebuilt.Verify(c), true)

	assert.Equal(t, tvcRebuilt.BKVC.Verify(c), true)
}
