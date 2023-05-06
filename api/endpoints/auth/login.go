package auth

import (
	"database/sql"
	"encoding/base64"
	"main/core"
	. "main/payloads"
	. "main/telemetry"
	"main/utils"
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
		ID              uuid.UUID            `db:"id" json:"id"`
		FirstName       string               `db:"first_name" json:"first_name"`
		MiddleName      *string              `db:"middle_name" json:"middle_name,omitempty"`
		LastName        string               `db:"last_name" json:"last_name"`
		DOB             *utils.UnixTimestamp `db:"dob" json:"dob"`
		Email           string               `db:"email" json:"email"`
		Password        string               `db:"password" json:"-"`
		IsVerified      bool                 `db:"is_verified" json:"is_verified"`
		TwoFactorAuth   sql.NullString       `db:"two_factor_auth" json:"-"`
		KeyPair         sql.NullString       `db:"pubkey" json:"-"`
		PubKeyUpdatedAt *utils.UnixTimestamp `db:"pubkey_updated_at" json:"-"`
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
	userBalance := 0.0
	row := core.DB.QueryRow(`
    SELECT users.id, users.first_name, users.middle_name, users.last_name, users.dob, users.email, users.password, users.is_verified, users.two_factor_auth, keys.value as keypair, keys.last_refreshed_at as pubkey_updated_at, a.balance
    FROM Users users
    LEFT JOIN Keys keys ON users.id = keys.associated_user AND keys.active = true
    LEFT JOIN Accounts a ON users.id = a.id
    WHERE users.email = $1;
    `, loginFormInput.Email,
	)

	err := row.Scan(&queryUser.ID, &queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.DOB, &queryUser.Email, &queryUser.Password, &queryUser.IsVerified, &queryUser.TwoFactorAuth, &queryUser.KeyPair, &queryUser.PubKeyUpdatedAt, &userBalance)

	if err == sql.ErrNoRows {
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"email", loginFormInput.Email,
		)

		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

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
			"id", queryUser.ID,
		)
		c.JSON(http.StatusForbidden, gin.H{"msg": msg, "user_id": queryUser.ID})
		return
	}

	if queryUser.TwoFactorAuth.Valid && queryUser.TwoFactorAuth.String != "" {
		temp_token := core.CreateTwoFATempToken(c, queryUser.ID, loginFormInput.RememberMe)

		tempExpiry := core.Configs.TWO_FA_TIMEOUT * int(time.Second)

		secure := true
		if core.Configs.DEV_MODE() {
			secure = false
		}

		c.SetCookie("temp_session", temp_token.String(), tempExpiry, "/", core.Configs.FRONTEND_HOST, secure, true)

		c.JSON(http.StatusOK, gin.H{"msg": "TwoFA required!", "two_fa_required": true})

		return
	}

	// Check for last key refresh time
	keyPair, lastRefreshedAt, err := core.GetUserKeyPair(c, queryUser.ID)

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to get existing user key",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	if keyPair.IsEmpty {
		Logger(c).Sugar().Errorw("First time login for user",
			"error", err,
		)
	}

	duration := time.Since(lastRefreshedAt)

	sendOnlyPub := true
	if duration.Hours() > float64(core.Configs.KEY_VALIDITY_TIME_HOURS) || keyPair.IsEmpty {
		keyPair, lastRefreshedAt, err = core.GenerateKeyPair(c, queryUser.ID)

		if err != nil {
			Logger(c).Sugar().Errorw("Failed to generate key pair",
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
			return
		}

		sendOnlyPub = false
	}

	secure := true
	if core.Configs.DEV_MODE() {
		secure = false
	}

	var expiry int
	if loginFormInput.RememberMe {
		expiry = core.Configs.SESSION_EXPIRE_TIME_EXTENDED
	} else {
		expiry = core.Configs.SESSION_EXPIRE_TIME
	}

	sessionToken := core.GenerateSessionToken(c, queryUser.ID, expiry)

	c.SetCookie("session", sessionToken.String(), expiry, "/", core.Configs.FRONTEND_HOST, secure, true)

	msg := "User logged in successfully!"
	l.Infow(msg,
		"id", queryUser.ID,
		"email", queryUser.Email,
		"first_name", queryUser.FirstName,
		"middle_name", queryUser.MiddleName,
		"last_name", queryUser.LastName,
	)

	bkvc := BalanceKeyVerificationCertificate{
		MessageType:      BKVCMessageType,
		UserID:           queryUser.ID,
		PublicKey:        [32]byte(keyPair.PublicKey()),
		AvailableBalance: float32(userBalance),
		TimeStamp:        time.Now(),
	}

	bkvc.Sign(c)

	base64EncodedBKVC := base64.StdEncoding.EncodeToString(bkvc.ToBytes(c))

	type loginUserReturn struct {
		ID         uuid.UUID            `db:"id" json:"id"`
		FirstName  string               `db:"first_name" json:"first_name"`
		MiddleName *string              `db:"middle_name" json:"middle_name,omitempty"`
		LastName   string               `db:"last_name" json:"last_name"`
		DOB        *utils.UnixTimestamp `db:"dob" json:"dob"`
		Email      string               `db:"email" json:"email"`
		IsVerified bool                 `db:"is_verified" json:"is_verified"`
		IsTwoFA    bool                 `json:"is_twofa"`
	}

	returnUser := &loginUserReturn{ID: queryUser.ID, FirstName: queryUser.FirstName, MiddleName: queryUser.MiddleName, LastName: queryUser.LastName, DOB: queryUser.DOB, Email: queryUser.Email, IsVerified: queryUser.IsVerified, IsTwoFA: queryUser.TwoFactorAuth.Valid && queryUser.TwoFactorAuth.String != ""}

	if sendOnlyPub {
		c.JSON(http.StatusAccepted, gin.H{"msg": msg, "primary": false, "bkvc": base64EncodedBKVC, "public_key": base64.StdEncoding.EncodeToString(keyPair.PublicKey()), "user": returnUser})
	} else {
		c.JSON(http.StatusAccepted, gin.H{"msg": msg, "primary": true, "bkvc": base64EncodedBKVC, "private_key": base64.StdEncoding.EncodeToString(keyPair.PrivateKey()), "user": returnUser})
	}
}
