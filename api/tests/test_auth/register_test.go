package test_auth

import (
	"encoding/json"
	"main/endpoints/auth"
	. "main/tests"
	"net/http"
	"net/http/httptest"
	"net/url"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRegister(t *testing.T) {
	// Set up the Gin router and controller
	authController := auth.RegisterController{}

	// Set up a test user
	values := url.Values{}
	values.Set("first_name", "John")
	values.Set("middle_name", "M.")
	values.Set("last_name", "Doe")
	values.Set("dob", "1990-01-01")
	values.Set("email", "john.doe@example.com")
	values.Set("password", "password")

	// Create a test request with the user data
	req, err := http.NewRequest("POST", "/v1/auth/register", nil)
	if err != nil {
		t.Fatal(err)
	}
	req.PostForm = values

	// Create a test response recorder and execute the request
	resp := httptest.NewRecorder()
	TestRouter.POST("/v1/auth/register", authController.Register)
	TestRouter.ServeHTTP(resp, req)

	// Check the response status code
	assert.Equal(t, http.StatusCreated, resp.Code)

	// Check the response data
	var respData map[string]interface{}
	err = json.Unmarshal(resp.Body.Bytes(), &respData)

	assert.Nil(t, err)
	assert.Equal(t, "User created successfully!", respData["msg"])
	assert.NotEmpty(t, respData["user_id"])
}
