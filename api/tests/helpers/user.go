package tests

import (
	"main/core"
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type TestUser struct {
	FirstName    string `form:"email"`
	LastName     string `form:"email"`
	Email        string `form:"email"`
	Password     string `form:"password"`
	DOB          string `form:"dob"`
	Remember     bool   `form:"remember"`
	Verified     bool
	SessionToken uuid.UUID
	UserId       uuid.UUID
}

func userCreator(t *testing.T, c *gin.Context, user *TestUser) *TestUser {
	hashedPassword, err := core.HashPassword(c, user.Password)

	if err != nil {
		t.Fatalf("failed to hash password: %v", err)
	}

	var userID uuid.UUID

	tx, err := core.DB.Begin()
	if err != nil {
		msg := "Failed to start transaction"
		t.Fatal(err)
		t.Fatal(msg)
	}

	query := `
    INSERT INTO Users
    (
        first_name,
        last_name,
        dob,
        password,
        email,
        is_verified
    )
    VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6
    )
    RETURNING id;
`

	err = tx.
		QueryRow(query, user.FirstName, user.LastName, user.DOB, hashedPassword, user.Email, user.Verified).
		Scan(&user.UserId)

	if err != nil {
		msg := "Failed to execute SQL statement"
		t.Logf(msg)
		t.Fatal(err)
		tx.Rollback()
	}

	accountsCreateQuery := "INSERT INTO Accounts (id, balance) VALUES ($1, $2)"

	_, err = tx.Exec(accountsCreateQuery, user.UserId, 0)

	if err != nil {
		msg := "Failed to execute account insert statement"
		t.Logf(msg)
		t.Fatal(err)
		tx.Rollback()
	}

	// Commit the transaction if both statements succeeded
	err = tx.Commit()
	if err != nil {
		t.Fatalf("failed to create test user: %v", err)
		tx.Rollback()
	}

	user.UserId = userID

	return user
}

func CreateJohnDoeUser(t *testing.T, c *gin.Context) TestUser {
	user := TestUser{
		FirstName: "John",
		LastName:  "Doe",
		DOB:       "1999-01-02",
		Email:     "test@example.com",
		Password:  "password",
		Remember:  false,
		Verified:  true,
	}

	userCreator(t, c, &user)

	return user
}

func CreateRandomUnverifiedUser(t *testing.T, c *gin.Context) TestUser {
	rand.Seed(time.Now().UnixNano())

	firstName := "John" + strconv.Itoa(rand.Intn(100))
	lastName := "Doe" + strconv.Itoa(rand.Intn(100))
	dob := strconv.Itoa(rand.Intn(28)+1) + "-" + strconv.Itoa(rand.Intn(12)+1) + "-1999"
	email := "test" + strconv.Itoa(rand.Intn(100)) + "@example.com"
	password := "password" + strconv.Itoa(rand.Intn(100))

	user := TestUser{
		FirstName: firstName,
		LastName:  lastName,
		DOB:       dob,
		Email:     email,
		Password:  password,
		Remember:  false,
		Verified:  false,
	}

	userCreator(t, c, &user)

	return user
}

func getRandomDate() string {
	minDate := time.Date(1970, 1, 1, 0, 0, 0, 0, time.UTC).Unix()
	maxDate := time.Now().Unix()

	randomUnixTime := rand.Int63n(maxDate-minDate) + minDate

	randomTime := time.Unix(randomUnixTime, 0)

	randomDateString := randomTime.Format("2006-01-02")

	return randomDateString
}

func CreateRandomVerifiedUser(t *testing.T, c *gin.Context) TestUser {
	rand.Seed(time.Now().UnixNano())

	firstName := "John" + strconv.Itoa(rand.Intn(100))
	lastName := "Doe" + strconv.Itoa(rand.Intn(100))
	dob := getRandomDate()
	email := "test" + strconv.Itoa(rand.Intn(100)) + "@example.com"
	password := "password" + strconv.Itoa(rand.Intn(100))

	user := TestUser{
		FirstName: firstName,
		LastName:  lastName,
		DOB:       dob,
		Email:     email,
		Password:  password,
		Remember:  false,
		Verified:  true,
	}

	userCreator(t, c, &user)

	return user
}

func CreateLoggedInUser(t *testing.T, c *gin.Context) TestUser {
	user := CreateRandomVerifiedUser(t, c)

	// Create a session token
	sessionToken := core.GenerateSessionToken(c, user.UserId, core.Configs.SESSION_EXPIRE_TIME)

	user.SessionToken = sessionToken

	return user
}
