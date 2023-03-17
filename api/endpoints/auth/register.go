package auth

import (
	"main/core"

	"net/http"

	"github.com/gin-gonic/gin"
)

type RegisterController struct{}

func (RegisterController) Register(c *gin.Context) {
	l := core.Logger(c).Sugar()

	var user struct {
		FirstName  string `form:"first_name"`
		MiddleName string `form:"middle_name"`
		LastName   string `form:"last_name"`
		DOB        string `form:"dob"`
		Email      string `form:"email"`
		Password   string `form:"password"`
	}

	if err := c.Bind(&user); err != nil {
		msg := "Invalid request payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
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

		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"msg": msg})
		return
	}

	passwordHash, err := core.HashPassword(c, user.Password)
	if err != nil {
		msg := "Failed to hash password!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured", "context": core.TraceIDFromContext(c)})
		return
	}

	query := `
      INSERT INTO users
      (
        first_name,
        middle_name,
        last_name,
        dob,
        password,
        email,
        pubkey_updated_at
      )
      VALUES
      (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7
      )
      RETURNING 
      id,
      first_name,
      middle_name,
      last_name,
      email,
      is_verified,
      pubkey_updated_at;
  `

	row := core.DB.QueryRow(query, user.FirstName, user.MiddleName, user.LastName, user.DOB, passwordHash, user.Email, nil)

	returnedUser := core.CommonUser{}

	err = row.Scan(&returnedUser.Id, &returnedUser.FirstName, &returnedUser.MiddleName, &returnedUser.LastName, &returnedUser.Email, &returnedUser.IsVerified, &returnedUser.PubKeyUpdatedAt)

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": core.TraceIDFromContext(c)})
		return
	}

	msg := "User created successfully!"

	core.SendVerificationEmail(c, &returnedUser)

	l.Infow(msg,
		"email", user.Email,
		"first_name", user.FirstName,
		"middle_name", user.MiddleName,
		"last_name", user.LastName,
	)
	c.JSON(http.StatusCreated, gin.H{"msg": msg, "user_id": returnedUser.Id})
}
