package test_auth

import (
	"bytes"
	"encoding/json"
	"main/endpoints/auth"
	. "main/tests/helpers"
	test "main/tests/helpers"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLogin(t *testing.T) {
	r, c, w := TestInit()

	loginController := auth.LoginController{}

	user := test.CreateRandomVerifiedUser(t, c)

	r.POST("/v1/auth/login", loginController.Login)

	// Make a test request to log in the user.
	requestBody, err := json.Marshal(map[string]interface{}{
		"email":    user.Email,
		"password": user.Password,
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
	assert.Equal(t, "User Logged in Successfully", responseBody["msg"])
}
