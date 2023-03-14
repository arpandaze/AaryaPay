package auth

import (
	"main/core"
	"net/http"

	"github.com/gin-gonic/gin"
)

type TwoFaController struct{}

func (TwoFaController) TwoFAEnableRequest(c *gin.Context) {
	l := core.Logger(c).Sugar()
	var twoFA struct {
		token string `form:"token"`
	}

	//TODO token gen
	uid, err := VerifyUserToken(twoFA.token)
	if false {
		panic(uid)
	}
	if err != nil {

		msg := "invalid or expired token"
		l.Warnw(msg,
			"err", msg,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
		return
	}

	uri := "totp"
	secret := "totp_secret"

	msg := "2FA enable Requested"
	l.Infow(msg) // "id", queryUser.ID,
	// "email", queryUser.Email,
	// "first_name", queryUser.FirstName,
	// "middle_name", queryUser.MiddleName,
	// "last_name", queryUser.LastName,

	c.JSON(http.StatusAccepted, gin.H{"msg": msg, "uri": uri, "secret": secret})
}
