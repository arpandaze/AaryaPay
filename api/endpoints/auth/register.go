package auth

import (
	"main/core"
	"main/telemetry"

	"net/http"

	"github.com/gin-gonic/gin"
)

type RegisterController struct{}

func (RegisterController) Register(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	var user struct {
		FirstName  string `form:"first_name" validate:"required"`
		MiddleName string `form:"middle_name"`
		LastName   string `form:"last_name" validate:"required"`
		DOB        string `form:"dob" validate:"required"`
		Email      string `form:"email" validate:"required,email"`
		Password   string `form:"password" validate:"required,min=8,max=128"`
	}

	if err := c.Bind(&user); err != nil {
		msg := "Invalid request payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	err := core.Validator.Struct(user)

	if err != nil {
		core.HandleValidationError(c, err)
		return
	}

	// Check if firstname and lastname are empty
	if user.FirstName == "" || user.LastName == "" {
		msg := "First Name and Last Name are required!"

		l.Warnw(msg,
			"first_name", user.FirstName,
			"last_name", user.LastName)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	// Ceck if DOB is empty
	if user.DOB == "" {
		msg := "Date of birth is required!"

		l.Warnw(msg,
			"dob", user.DOB)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	// Check if email is already used
	var exists bool
	core.DB.QueryRow("SELECT EXISTS (SELECT id FROM Users WHERE email=$1)", user.Email).Scan(&exists)

	if exists {
		msg := "Email already exists!"

		l.Warnw(msg,
			"email", user.Email,
		)

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
		return
	}

	passwordHash, err := core.HashPassword(c, user.Password)
	if err != nil {
		msg := "Failed to hash password!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured", "context": telemetry.TraceIDFromContext(c)})
		return
	}
    // id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    // photo_url VARCHAR(255),
    // first_name VARCHAR(50) NOT NULL,
    // middle_name VARCHAR(50),
    // last_name VARCHAR(50) NOT NULL,
    // dob DATE NOT NULL,
    // password VARCHAR(255) NOT NULL,
    // email VARCHAR(255) NOT NULL UNIQUE,
    // is_verified BOOLEAN DEFAULT false NOT NULL,
    // two_factor_auth VARCHAR(255),
    // last_sync TIMESTAMP,
    // created_at TIMESTAMP DEFAULT NOW()


	query := `
      INSERT INTO Users
      (
        first_name,
        middle_name,
        last_name,
        dob,
        password,
        email
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
      RETURNING 
      id,
      first_name,
      middle_name,
      last_name,
      email,
      is_verified,
      last_sync;
  `

	row := core.DB.QueryRow(query, user.FirstName, user.MiddleName, user.LastName, user.DOB, passwordHash, user.Email)

	returnedUser := core.CommonUser{}

	err = row.Scan(&returnedUser.Id, &returnedUser.FirstName, &returnedUser.MiddleName, &returnedUser.LastName, &returnedUser.Email, &returnedUser.IsVerified, &returnedUser.LastSync)

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	accountsCreateQuery := "INSERT INTO Accounts (id, balance) VALUES ($1, $2)"
	_, err = core.DB.Exec(accountsCreateQuery, returnedUser.Id, 0)

	if err != nil {
		l.Errorw("Failed to create account for user!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	msg := "User created successfully!"

	_, err = core.SendVerificationEmail(c, &returnedUser)
	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to send verification email",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	l.Infow(msg,
		"email", user.Email,
		"first_name", user.FirstName,
		"middle_name", user.MiddleName,
		"last_name", user.LastName,
	)
	c.JSON(http.StatusCreated, gin.H{"msg": msg, "user_id": returnedUser.Id})
}
