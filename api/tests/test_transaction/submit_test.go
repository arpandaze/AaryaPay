package test_auth

import (
	"encoding/base64"
	"main/core"
	"main/endpoints/transaction"
	"main/payloads"
	. "main/tests/helpers"
	test "main/tests/helpers"
	"net/http"
	"net/url"
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestSubmitTransaction(t *testing.T) {
	r, c, w := TestInit()

	submitController := transaction.SubmitController{}

	receiver := test.CreateUserWithKeyPair(t, c)
	sender := test.CreateUserWithKeyPair(t, c)

	beforeReceiverBalance := 0.0
	beforeSenderBalance := 0.0
	core.DB.QueryRow("SELECT balance FROM Accounts WHERE id = $1", receiver.UserId).Scan(&beforeReceiverBalance)
	core.DB.QueryRow("SELECT balance FROM Accounts WHERE id = $1", sender.UserId).Scan(&beforeSenderBalance)

	testBKVC := payloads.BalanceKeyVerificationCertificate{
		UserID:           sender.UserId,
		AvailableBalance: 100,
		PublicKey:        [32]byte(sender.KeyPair.PublicKey()),
		TimeStamp:        time.Now(),
	}

	testBKVC.Sign(c)

	testTransaction := payloads.Transaction{
		Amount:    85,
		To:        receiver.UserId,
		BKVC:      testBKVC,
		TimeStamp: time.Now(),
	}

	testTransaction.Sign(c, sender.KeyPair.PrivateKey())

	r.POST("/v1/transaction", submitController.Submit)

	// Make a test request to log in the user.
	requestBody := url.Values{}
	requestBody.Set("transactions", base64.StdEncoding.EncodeToString(testTransaction.ToBytes(c)))

	req, err := http.NewRequest("POST", "/v1/transaction", strings.NewReader(requestBody.Encode()))
	if err != nil {
		t.Fatalf("failed to create test request: %v", err)
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	r.ServeHTTP(w, req)

	// Check that the response status code is as expected.
	assert.Equal(t, http.StatusAccepted, w.Code)

	afterReceiverBalance := 0.0
	afterSenderBalance := 0.0
	core.DB.QueryRow("SELECT balance FROM Accounts WHERE id = $1", receiver.UserId).Scan(&afterReceiverBalance)
	core.DB.QueryRow("SELECT balance FROM Accounts WHERE id = $1", sender.UserId).Scan(&afterSenderBalance)

	assert.Equal(t, beforeReceiverBalance+85, afterReceiverBalance)
	assert.Equal(t, beforeSenderBalance-85, afterSenderBalance)
}
