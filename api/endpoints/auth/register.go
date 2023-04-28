package auth

import (
	"main/core"
	"main/telemetry"
	"main/utils"

	"net/http"

	"github.com/gin-gonic/gin"
)

type RegisterController struct{}

func (RegisterController) Register(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	var user struct {
		FirstName  string              `form:"first_name" validate:"required"`
		MiddleName string              `form:"middle_name"`
		LastName   string              `form:"last_name" validate:"required"`
		DOB        utils.UnixTimestamp `form:"dob" validate:"required"`
		Email      string              `form:"email" validate:"required,email"`
		Password   string              `form:"password" validate:"required,min=8,max=128"`
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

	tx, err := core.DB.Begin()
	if err != nil {
		msg := "Failed to start transaction"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

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

	returnedUser := core.CommonUser{}

	err = tx.QueryRow(query, user.FirstName, user.MiddleName, user.LastName, user.DOB.Time(), passwordHash, user.Email).Scan(
		&returnedUser.Id, &returnedUser.FirstName, &returnedUser.MiddleName, &returnedUser.LastName, &returnedUser.Email,
		&returnedUser.IsVerified, &returnedUser.LastSync)

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		tx.Rollback()
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	accountsCreateQuery := "INSERT INTO Accounts (id, balance) VALUES ($1, $2)"

	_, err = tx.Exec(accountsCreateQuery, returnedUser.Id, 0)

	if err != nil {
		l.Errorw("Failed to create account for user!",
			"error", err,
		)
		tx.Rollback()
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	// Commit the transaction if both statements succeeded
	err = tx.Commit()
	if err != nil {
		l.Errorw("Failed to commit transaction",
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
