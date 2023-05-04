package auth

import (
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"fmt"

	"main/core"
	"main/telemetry"
	"main/utils"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/pquerna/otp/totp"
)

type TwoFaController struct{}

func (TwoFaController) TwoFAEnableRequest(c *gin.Context) {
	l := telemetry.Logger(c).Sugar()

	user, err := core.GetActiveUser(c)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
	}

	type TwoFAUserStruct struct {
		Id            uuid.UUID `db:"id"`
		Email         string    `db:"email"`
		TwoFactorAuth *string   `db:"two_factor_auth"`
	}

	twoFAUser := TwoFAUserStruct{}

	row := core.DB.QueryRow(`
	SELECT id, email, two_factor_auth
	FROM 
	users 
	WHERE 
	id=$1
    `, user,
	)

	err = row.Scan(&twoFAUser.Id, &twoFAUser.Email, &twoFAUser.TwoFactorAuth)

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	if twoFAUser.TwoFactorAuth != nil {
		msg := "TwoFA is already enabled!"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"error": msg})
		return
	}
	totp_key, err := totp.Generate(totp.GenerateOpts{
		Issuer:      core.Configs.PROJECT_NAME,
		AccountName: twoFAUser.Email,
	})

	if err != nil {
		msg := "Failed to generate totp!"
		l.Errorw("Failed to generate totp!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
	}

	key := fmt.Sprint("two_fa_enable_temp_", twoFAUser.Id)
	duration := time.Duration(core.Configs.TWO_FA_TIMEOUT * int(time.Second))
	core.Redis.SetEx(c, key, totp_key.Secret(), duration)

	msg := "TwoFA enable Requested"

	l.Infow(msg,
		"id", twoFAUser.Id,
		"email", twoFAUser.Email,
		"msg", msg,
	)

	c.JSON(http.StatusAccepted, gin.H{"msg": msg, "uri": totp_key.URL(), "secret": totp_key.Secret()})
}

func (TwoFaController) TwoFAEnableConfirm(c *gin.Context) {

	l := telemetry.Logger(c).Sugar()

	var twoFACode struct {
		Passcode string `form:"passcode"`
	}

	if err := c.Bind(&twoFACode); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	user, err := core.GetActiveUser(c)

	if err != nil {
		telemetry.Logger(c).Sugar().Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
	}

	type TwoFAUserStruct struct {
		TwoFactorAuth *string `db:"two_factor_auth"`
	}

	twoFAUser := TwoFAUserStruct{}

	row := core.DB.QueryRow(`
	SELECT two_factor_auth
	FROM 
	users 
	WHERE 
	id=$1
    `, user,
	)

	err = row.Scan(&twoFAUser.TwoFactorAuth)

	if err != nil {
		msg := "Failed to execute SQL statement"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	if twoFAUser.TwoFactorAuth != nil {
		msg := "TwoFA is already enabled!"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusConflict, gin.H{"error": msg})
		return
	}

	key := fmt.Sprint("two_fa_enable_temp_", user.String())
	totp_secret := core.Redis.Get(c, key)
	if err := totp_secret.Err(); err != nil {
		l.Errorw("Failed to get session details!",
			"error", err,
		)
		return
	}

	valid := totp.Validate(twoFACode.Passcode, totp_secret.Val())

	if !valid {
		msg := "Invalid OTP!"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
		return
	}

	query := `
		UPDATE users
		SET two_factor_auth = $1
		WHERE id = $2
	`

	_, err = core.DB.Exec(query, totp_secret.Val(), user)

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	status := core.Redis.Del(c, key)
	if err := status.Err(); err != nil {
		l.Errorw("Failed to delete session token!",
			"error", err,
		)

		return
	}

	msg := "TwoFA successfully enabled!"

	l.Infow(msg,
		"id", user.String(),
		"msg", msg,
	)

	c.JSON(http.StatusAccepted, gin.H{"msg": msg})

}

func (TwoFaController) TwoFALoginConfirm(c *gin.Context) {

	l := telemetry.Logger(c).Sugar()

	var twoFACode struct {
		Passcode string `form:"passcode"`
	}

	if err := c.Bind(&twoFACode); err != nil {
		msg := "Invalid Request Payload"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
		return
	}

	tempSessionToken, err := c.Cookie("temp_session")

	if err != nil {
		l.Errorw("Error fetching cookie", "error", err)
		return
	}

	cookieUUID, err := uuid.Parse(tempSessionToken)

	if err != nil {
		l.Errorw("Error while parsing token", "error", err)
		return
	}

	key := fmt.Sprint("two_fa_temp_", cookieUUID)
	status := core.Redis.Get(c, key)

	if err := status.Err(); err != nil {
		l.Errorw("Failed to get verification token from key!", "error", err)

		return
	}

	type tempTokenStruct struct {
		UserId     uuid.UUID `json:"UserId"`
		RememberMe bool      `json:"RememberMe"`
	}

	var tempData tempTokenStruct
	err = json.Unmarshal([]byte(status.Val()), &tempData)

	if err != nil {
		l.Errorw("Failed to Unmarshall Redis value", "error", err)
		return
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

	queryUser := loginUser{}
	userBalance := 0.0
	row := core.DB.QueryRow(`
    SELECT users.id, users.first_name, users.middle_name, users.last_name, users.dob, users.email, users.password, users.is_verified, users.two_factor_auth, keys.value as keypair, keys.last_refreshed_at as pubkey_updated_at, a.balance
    FROM Users users
    LEFT JOIN Keys keys ON users.id = keys.associated_user AND keys.active = true
    LEFT JOIN Accounts a ON users.id = a.id
    WHERE users.email = $1;
    `, tempData.UserId,
	)

	err = row.Scan(&queryUser.ID, &queryUser.FirstName, &queryUser.MiddleName, &queryUser.LastName, &queryUser.DOB, &queryUser.Email, &queryUser.Password, &queryUser.IsVerified, &queryUser.TwoFactorAuth, &queryUser.KeyPair, &queryUser.PubKeyUpdatedAt, &userBalance)

	switch err {
	case sql.ErrNoRows:
		msg := "No account associated with the email was found"

		l.Warnw(msg,
			"user", status.Val(),
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": msg})
	case nil:
		{
			if !queryUser.TwoFactorAuth.Valid {
				msg := "TwoFA is not enabled!"
				l.Errorw(msg,
					"error", err,
				)
				c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})

				return
			}

			valid := totp.Validate(twoFACode.Passcode, queryUser.TwoFactorAuth.String)

			if !valid {
				msg := "Invalid OTP!"
				l.Errorw(msg,
					"error", err,
				)
				c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
				return
			}

			// Check for last key refresh time
			_, lastRefreshedAt, err := core.GetUserKeyPair(c, queryUser.ID)

			if err != nil {
				l.Errorw("Failed to get existing user key",
					"error", err,
				)
				c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
				return
			}

			duration := time.Since(lastRefreshedAt)

			if duration.Hours() < float64(core.Configs.KEY_VALIDITY_TIME_HOURS) {
				msg := "Please logout from previous device or wait for the key to expire!"
				l.Errorw(msg)

				c.AbortWithStatusJSON(http.StatusTooEarly, gin.H{"msg": msg, "context": telemetry.TraceIDFromContext(c)})
				return
			}

			keyPair, lastRefreshedAt, err := core.GenerateKeyPair(c, queryUser.ID)

			if err != nil {
				l.Errorw("Failed to generate key pair",
					"error", err,
				)
				c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
				return
			}
			secure := true
			if core.Configs.DEV_MODE() {
				secure = false

			}

			var expiry int
			if tempData.RememberMe {
				expiry = core.Configs.SESSION_EXPIRE_TIME_EXTENDED
			} else {
				expiry = core.Configs.SESSION_EXPIRE_TIME
			}

			sessionToken := core.GenerateSessionToken(c, queryUser.ID, expiry)

			c.SetCookie("temp_session", "", -1, "/", "", false, true)
			c.SetCookie("session", sessionToken.String(), expiry, "/", core.Configs.FRONTEND_HOST, secure, true)

			status := core.Redis.Del(c, key)
			if err := status.Err(); err != nil {
				l.Errorw("Failed to delete session token!",
					"error", err,
				)

				return
			}

			msg := "User Logged in Successfully"
			l.Infow(msg,
				"id", queryUser.ID,
				"email", queryUser.Email,
				"first_name", queryUser.FirstName,
				"middle_name", queryUser.MiddleName,
				"last_name", queryUser.LastName,
			)

			bkvc := core.BalanceKeyVerificationCertificate{
				MessageType:      core.BKVCMessageType,
				UserID:           queryUser.ID,
				PublicKey:        [32]byte(keyPair.PublicKey()),
				AvailableBalance: float32(userBalance),
				TimeStamp:        time.Now(),
			}

			bkvc.Sign(c)

			base64EncodedBKVC := base64.StdEncoding.EncodeToString(bkvc.ToBytes(c))

			c.JSON(http.StatusAccepted, gin.H{"msg": msg, "bkvc": base64EncodedBKVC, "private_key": base64.StdEncoding.EncodeToString(keyPair.PrivateKey()), "user": queryUser})
			return
		}
	default:
		{
			msg := "Failed to execute SQL statement"
			l.Errorw(msg,
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
			return
		}
	}

}

func (TwoFaController) TwoFADisable(c *gin.Context) {

	l := telemetry.Logger(c).Sugar()

	user, err := core.GetActiveUser(c)

	if err != nil {
		l.Errorw("Failed to extract user!",
			"error", err,
		)
		msg := "Invalid or expired session!"
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": msg})
	}
	query := `
		UPDATE users
		SET two_factor_auth = $1
		WHERE id = $2
	`

	_, err = core.DB.Exec(query, "", user)

	if err != nil {
		msg := "Failed to execute SQL statement"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	msg:= "TwoFA disabled successfully"
	c.JSON(http.StatusAccepted, gin.H{"msg": msg})
}