package auth

import (
	"database/sql"
	"main/core"
	. "main/telemetry"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type LoginController struct{}

func (LoginController) Login(c *gin.Context) {
	l := Logger(c).Sugar()

	var loginFormInput struct {
		Email      string `form:"email"`
		Password   string `form:"password"`
		RememberMe bool   `form:"remember_me"`
	}

	type loginUser struct {
		ID              uuid.UUID      `db:"id"`
		FirstName       string         `db:"first_name"`
		MiddleName      sql.NullString `db:"middle_name"`
		LastName        string         `db:"last_name"`
		DOB             string         `db:"dob"`
		Email           string         `db:"email"`
		Password        string         `db:"password"`
		IsVerified      bool           `db:"is_verified"`
		PubKey          sql.NullString `db:"pubkey"`
		PubKeyUpdatedAt sql.NullTime   `db:"pubkey_updated_at"`
	}

	if err := c.Bind(&loginFormInput); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	queryUser := loginUser{}
	row := core.DB.QueryRow(`
	SELECT id, first_name, middle_name, last_name, dob, email, password, is_verified, pubkey, pubkey_updated_at
	FROM 
	Users 
	WHERE 
	email=$1
    `, loginFormInput.Email,
	)

	err := row.Scan(&queryUser.ID, &queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.DOB, &queryUser.Email, &queryUser.Password, &queryUser.IsVerified, &queryUser.PubKey, &queryUser.PubKeyUpdatedAt)

	switch err {
	case sql.ErrNoRows:
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"email", loginFormInput.Email,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return

	case nil:
		{
			passwordVerified, err := core.VerifyPassword(c, loginFormInput.Password, queryUser.Password)

			if err != nil {
				msg := "Failed to verify password!"
				l.Warnw(msg, "error", err)
				c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
				return
			}

			if !passwordVerified {
				msg := "The password entered is incorrect"
				l.Warnw(msg,
					"email", queryUser.Email,
				)
				c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
				return
			}

			if !queryUser.IsVerified {

				msg := "Please verify the account first!"
				l.Warnw(msg,
					"email", queryUser.Email,
				)
				c.JSON(http.StatusUnauthorized, gin.H{"msg": msg, "user_id": queryUser.ID})
				return
			}

			var expiry int
			if loginFormInput.RememberMe {
				expiry = core.Configs.SESSION_EXPIRE_TIME_EXTENDED
			} else {
				expiry = core.Configs.SESSION_EXPIRE_TIME
			}

			sessionToken := core.GenerateSessionToken(c, queryUser.ID, expiry)

			_, lastRefreshedAt, err := core.GetUserKey(c, queryUser.ID)

			if err != nil {
				Logger(c).Sugar().Errorw("Failed to get existing user key",
					"error", err,
				)
				c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
				return
			}

			duration := time.Since(lastRefreshedAt)

			if duration.Hours() < float64(core.Configs.KEY_VALIDITY_TIME_HOURS) {
				msg := "Please logout from previous device or wait for the key to expire!"
				l.Errorw(msg)

				c.AbortWithStatusJSON(http.StatusTooEarly, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
				return
			} else {
				pubKey, privKey, lastRefreshedAt, signature, err := core.GenerateKeyPair(c, queryUser.ID)

				if err != nil {
					Logger(c).Sugar().Errorw("Failed to generate key pair",
						"error", err,
					)
					c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
					return
				}

				secure := true
				if core.Configs.DEV_MODE() {
					secure = false
				}

				c.SetCookie("session", sessionToken.String(), expiry, "/", core.Configs.FRONTEND_HOST, secure, true)

				msg := "User Logged in Successfully"
				l.Infow(msg,
					"id", queryUser.ID,
					"email", queryUser.Email,
					"first_name", queryUser.FirstName,
					"middle_name", queryUser.MiddleName,
					"last_name", queryUser.LastName,
				)
				c.JSON(http.StatusAccepted, gin.H{"msg": msg, "user_id": queryUser.ID, "pub_key": pubKey, "priv_key": privKey, "signature": signature, "last_refreshed": lastRefreshedAt.Unix()})
				return
			}
		}

	default:
		{
			msg := "Failed to execute SQL statement"
			l.Errorw(msg,
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
			return
		}
	}
}
