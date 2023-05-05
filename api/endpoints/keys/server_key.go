package keys

import (
	"crypto/ed25519"
	"encoding/base64"
	. "main/core"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ServerKeysController struct{}

func (ServerKeysController) ServerPubKey(c *gin.Context) {
	msg := "Hello #LC!"
	signature := ed25519.Sign(Configs.PRIVATE_KEY(), []byte(msg))

	staticPublicKey := Configs.PUBLIC_KEY()

	pubKeyBase64 := base64.StdEncoding.EncodeToString(staticPublicKey[:])

	c.JSON(http.StatusOK, gin.H{
		"pubkey":    pubKeyBase64,
		"message":   msg,
		"signature": signature,
	})
}
