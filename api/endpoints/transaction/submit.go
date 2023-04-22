package transaction

import (
	"fmt"
	. "main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
)

type SubmitController struct{}

func (SubmitController) Submit(c *gin.Context) {
	l := Logger(c).Sugar()

	var transactionSubmitForm struct {
		EncodedTransactions []string `form:"transactions"`
	}

	if err := c.Bind(&transactionSubmitForm); err != nil {
		msg := "Invalid request payload on transaction submission!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	fmt.Println(transactionSubmitForm.EncodedTransactions)

	c.JSON(http.StatusOK, gin.H{
		"status": "transaction submit",
	})
}
