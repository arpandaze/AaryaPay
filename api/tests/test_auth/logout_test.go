package test_auth

import (
	"main/endpoints/auth"
	"main/endpoints/tools"
	. "main/tests/helpers"
	"net/http"
	"strings"
	"testing"
)

func TestLogout(t *testing.T) {
	r, c, w := TestInit()

	// Create a new test user
	user := CreateLoggedInUser(t, c)

	logoutController := auth.LogoutController{}

	var err error
	c.Request, err = http.NewRequest("POST", "/v1/auth/logout", nil)
	if err != nil {
		t.Fatal(err)
	}

	// Set the session cookie in the request
	cookie := http.Cookie{
		Name:  "session",
		Value: user.SessionToken.String(),
	}

	c.Request.AddCookie(&cookie)

	// Perform the request
	r.POST("/v1/auth/logout", logoutController.Logout)
	r.ServeHTTP(w, c.Request)

	// Check the response status code
	if w.Code != http.StatusOK {
		t.Errorf("expected status %d but got %d", http.StatusOK, w.Code)
	}

	// Check that the session cookie has been deleted
	cookies := w.Header().Values("Set-Cookie")
	if len(cookies) > 0 {
		for _, cookie := range cookies {
			if strings.HasPrefix(cookie, "session=") {
				if !strings.Contains(cookie, "Max-Age=0") {
					t.Errorf("expected session cookie to be deleted but got %s", cookie)
				}
			}
		}
	}

	// Check that the user is no longer authenticated
	r, c, w = TestInit()

	authCheckController := tools.AuthCheckController{}

	c.Request, err = http.NewRequest("GET", "/utils/auth_check", nil)
	if err != nil {
		t.Fatal(err)
	}

	cookie = http.Cookie{
		Name:  "session",
		Value: user.SessionToken.String(),
	}

	c.Request.AddCookie(&cookie)

	r.GET("/utils/auth_check", authCheckController.AuthCheck)

	r.ServeHTTP(w, c.Request)

	if w.Code != http.StatusUnauthorized {
		t.Errorf("expected status %d but got %d", http.StatusUnauthorized, w.Code)
	}
}
