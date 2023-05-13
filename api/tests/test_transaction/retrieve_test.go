package test_auth

import (
	"main/endpoints/sync"
	. "main/tests/helpers"
	test "main/tests/helpers"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestTransactionRetrieve(t *testing.T) {
	r, c, w := TestInit()

	retrieveController := sync.TransactionRetrieve{}

	user := test.CreateLoggedInUser(t, c)

	r.GET("/v1/transaction", retrieveController.Retrieve)

	// Set cookie with user session user.SessionToken

	req, err := http.NewRequest("GET", "/v1/transaction", nil)

	cookie := http.Cookie{Name: "session", Value: user.SessionToken.String()}
	req.AddCookie(&cookie)

	if err != nil {
		t.Fatalf("failed to create test request: %v", err)
	}

	r.ServeHTTP(w, req)

	// Check that the response status code is as expected.
	assert.Equal(t, http.StatusOK, w.Code)
}
