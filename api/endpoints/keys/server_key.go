package keys

import (
	"crypto/ed25519"
	. "main/core"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ServerKeysController struct{}

func (ServerKeysController) ServerPubKey(c *gin.Context) {
	msg := "Hello #LC!"
	c.JSON(http.StatusOK, gin.H{
		"pubkey":    Configs.PUBLIC_KEY(),
		"message":   msg,
		"signature": ed25519.Sign(Configs.PRIVATE_KEY(), []byte(msg)),
	})
}
