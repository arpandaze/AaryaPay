package auth

import (
	"database/sql"
	"main/core"
	"net/http"

	"github.com/gin-gonic/gin"
)

type PasswordChangeController struct{}

func (PasswordChangeController) PasswordChange(c *gin.Context) {
	l := core.Logger(c).Sugar()
	var passwordChange struct {
		token            string `form:"token"`
		current_password string `form:"current_password"`
		new_password     string `form:"new_password"`
	}
	type loginUser struct {
		Email           string `db:"email"`
		Password        string `db:"password"`
		IsVerified      bool   `db:"is_verified"`
		PubKey          string `db:"pubkey"`
		PubKeyUpdatedAt string `db:"pub_key_updated_at"`
	}
	if err := c.Bind(&passwordChange); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	uid, err := VerifyUserToken(passwordChange.token)

	if err != nil {
		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
		return
	}

	queryUser := &loginUser{}
	row := core.DB.QueryRow(`
	SELECT email, password, is_verified, pubkey, pubkey_updated_at 
	FROM 
		Users 
	WHERE id=$1
	`, uid,
	)

	err = row.Scan(&queryUser.Email, &queryUser.Password, &queryUser.IsVerified, &queryUser.PubKey, &queryUser.PubKeyUpdatedAt)

	switch err {
	case sql.ErrNoRows:
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"email", queryUser.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg})

	case nil:
		passwordTest, err := core.VerifyPassword(c, passwordChange.current_password, queryUser.Password)
		if err != nil {
			msg := "Failed to verify password!"
			l.Warnw(msg, "error", err)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": core.TraceIDFromContext(c)})
			return
		}
		if !passwordTest {
		
			msg := "The password entered is incorrect"
			l.Warnw(msg,
				"email", queryUser.Email,
			)
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
			return
		}
		if !queryUser.IsVerified {
			msg := "Please verify the account first!"
			l.Warnw(msg,
				"email", queryUser.Email,
			)
			c.JSON(http.StatusUnauthorized, gin.H{"msg": msg})
			return
		}

		passwordHash, err := core.HashPassword(c, passwordChange.new_password)
		if err != nil {
			msg := "Failed to hash password!"

			l.Errorw(msg,
				"error", err,
			)

			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured", "context": core.TraceIDFromContext(c)})
			return
		}

		_, err = core.DB.Exec("UPDATE Users SET password=$1 WHERE id=$2", passwordHash, uid)

		if err != nil {
			msg := "Failed to execute SQL statement"
			l.Errorw(msg,
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": core.TraceIDFromContext(c)})
			return
		}

		msg := "Password Changed Successfully"
		l.Infow(msg,
			"id", uid,
			"email", queryUser.Email,
		)
		c.JSON(http.StatusAccepted, gin.H{"msg": msg})
		return

	default:
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to execute SQL statement"})
		return
	}
}
