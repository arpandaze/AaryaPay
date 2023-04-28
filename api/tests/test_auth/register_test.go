package test_auth

import (
	"encoding/json"
	"main/endpoints/auth"
	. "main/tests/helpers"
	"net/http"
	"net/url"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRegister(t *testing.T) {
	r, _, w := TestInit()
	// Set up the Gin router and controller
	authController := auth.RegisterController{}

	// Set up a test user
	values := url.Values{}
	values.Set("first_name", "John")
	values.Set("middle_name", "M.")
	values.Set("last_name", "Doe")
	values.Set("dob", "996624000")
	values.Set("email", "john.doe@example.com")
	values.Set("password", "password")

	// Create a test request with the user data
	req, err := http.NewRequest("POST", "/v1/auth/register", nil)
	if err != nil {
		t.Fatal(err)
	}
	req.PostForm = values

	// Create a test response recorder and execute the request
	r.POST("/v1/auth/register", authController.Register)
	r.ServeHTTP(w, req)

	// Check the response status code
	assert.Equal(t, http.StatusCreated, w.Code)

	// Check the response data
	var respData map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &respData)

	assert.Nil(t, err)
	assert.Equal(t, "User created successfully!", respData["msg"])
	assert.NotEmpty(t, respData["user_id"])
}
