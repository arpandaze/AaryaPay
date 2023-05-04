package test_auth

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"main/endpoints/auth"
	. "main/tests/helpers"
	test "main/tests/helpers"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
)

var cachedUser test.TestUser

func TestLogin(t *testing.T) {
	r, c, w := TestInit()

	loginController := auth.LoginController{}

	cachedUser = test.CreateRandomVerifiedUser(t, c)

	r.POST("/v1/auth/login", loginController.Login)

	// Make a test request to log in the user.
	requestBody, err := json.Marshal(map[string]interface{}{
		"email":    cachedUser.Email,
		"password": cachedUser.Password,
	})
	if err != nil {
		t.Fatalf("failed to marshal request body: %v", err)
	}
	req, err := http.NewRequest("POST", "/v1/auth/login", bytes.NewBuffer(requestBody))
	if err != nil {
		t.Fatalf("failed to create test request: %v", err)
	}
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	// Check that the response status code is as expected.
	assert.Equal(t, http.StatusAccepted, w.Code)

	// Check that the session cookie was set.
	assert.Equal(t, "session", w.Header().Get("Set-Cookie")[:7])

	// Check that the response body contains the expected message.
	var responseBody map[string]interface{}
	if err := json.Unmarshal(w.Body.Bytes(), &responseBody); err != nil {
		t.Fatalf("failed to unmarshal response body: %v", err)
	}

	// Check that private key is returned
	privateKey := responseBody["private_key"].(string)
	privateKeyBytes, err := base64.StdEncoding.DecodeString(privateKey)

	assert.Equal(t, len(privateKeyBytes), 64)

	// Check that primary is true
	assert.Equal(t, true, responseBody["primary"])
}

func TestOnlyPubOnSecondLogin(t *testing.T) {
	r, _, w := TestInit()

	loginController := auth.LoginController{}

	r.POST("/v1/auth/login", loginController.Login)

	// Make a test request to log in the user.
	requestBody, err := json.Marshal(map[string]interface{}{
		"email":    cachedUser.Email,
		"password": cachedUser.Password,
	})
	if err != nil {
		t.Fatalf("failed to marshal request body: %v", err)
	}
	req, err := http.NewRequest("POST", "/v1/auth/login", bytes.NewBuffer(requestBody))
	if err != nil {
		t.Fatalf("failed to create test request: %v", err)
	}
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	// Check that the response status code is as expected.
	assert.Equal(t, http.StatusAccepted, w.Code)

	// Check that the session cookie was set.
	assert.Equal(t, "session", w.Header().Get("Set-Cookie")[:7])

	// Check that the response body contains the expected message.
	var responseBody map[string]interface{}
	if err := json.Unmarshal(w.Body.Bytes(), &responseBody); err != nil {
		t.Fatalf("failed to unmarshal response body: %v", err)
	}

	// Check that private key is returned
	privateKey := responseBody["private_key"]

	assert.Equal(t, privateKey, nil)

	// Check that private key is returned
	publicKey := responseBody["public_key"].(string)
	publicKeyBytes, err := base64.StdEncoding.DecodeString(publicKey)

	assert.Equal(t, len(publicKeyBytes), 32)

	// Check that primary is false
	assert.Equal(t, false, responseBody["primary"])
}
