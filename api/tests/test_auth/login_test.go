package test_auth

import (
	"bytes"
	"encoding/json"
	"main/core"
	"main/endpoints/auth"
	. "main/tests"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLogin(t *testing.T) {
	loginController := auth.LoginController{}

	// Create a test user.
	user := struct {
		FirstName string `form:"email"`
		LastName  string `form:"email"`
		Email     string `form:"email"`
		Password  string `form:"password"`
		DOB       string `form:"dob"`
		Remember  bool   `form:"remember"`
	}{
		FirstName: "John",
		LastName:  "Doe",
		DOB:       "1999-01-02",
		Email:     "test@example.com",
		Password:  "password",
		Remember:  false,
	}

	TestRouter.POST("/v1/auth/login", loginController.Login)
	w := httptest.NewRecorder()

	hashedPassword, err := core.HashPassword(nil, user.Password)

	if err != nil {
		t.Fatalf("failed to hash password: %v", err)
	}

	if _, err := core.DB.Exec(`
		INSERT INTO users (first_name, last_name, dob, email, password, is_verified)
		VALUES ($1, $2, $3, $4, $5, true)
	`, user.FirstName, user.LastName, user.DOB, user.Email, hashedPassword); err != nil {
		t.Fatalf("failed to create test user: %v", err)
	}

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
	TestRouter.ServeHTTP(w, req)

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
