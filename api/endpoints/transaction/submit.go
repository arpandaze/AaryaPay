package transaction

import (
	"encoding/base64"
	"main/core"
	. "main/telemetry"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type SubmitController struct{}

func (SubmitController) Submit(c *gin.Context) {
	l := Logger(c).Sugar()

	var transactionSubmitForm struct {
		EncodedTransactions string `form:"transactions"`
	}

	if err := c.Bind(&transactionSubmitForm); err != nil {
		msg := "Invalid request payload on transaction submission!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	transactionsBytes, err := base64.RawStdEncoding.DecodeString(transactionSubmitForm.EncodedTransactions)

	if err != nil {
		msg := "Invalid transaction!"

		l.Errorw("Failed to decode base64 transaction!",
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	transaction, err := core.TransactionFromBytes(c, transactionsBytes)
	if err != nil {
		msg := "Invalid transaction!"

		l.Errorw("Failed to construct transaction from bytes!",
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	timeLimit := int64(core.Configs.KEY_VALIDITY_TIME_HOURS) * 60 * 60

	if transaction.TimeStamp.Unix() < time.Now().Unix()-timeLimit {
		msg := "Transaction is too old!"

		l.Errorw(msg,
			"error", err,
			"transaction", transactionSubmitForm.EncodedTransactions,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	validTransaction := transaction.Verify(c)

	if !validTransaction {
		msg := "Invalid transaction!"

		l.Errorw("Failed to verify transaction!",
			"transaction", transactionSubmitForm.EncodedTransactions,
			"error", err)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	if transaction.BKVC.Verify(c) {
		msg := "Invalid transaction!"

		l.Errorw("Failed to verify BKVC in transaction!",
			"transaction", transactionSubmitForm.EncodedTransactions,
			"error", err)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	var transactionId uuid.UUID
	var verificationTime time.Time
	err = core.DB.QueryRow("INSERT INTO Transactions (sender_id, receiver_id, amount, generation_time) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id, verification_time",
		transaction.BKVC.UserID, transaction.To, transaction.Amount, transaction.TimeStamp, time.Now(),
	).Scan(&transactionId, &verificationTime)

	if err != nil {
		l.Errorw("Failed to insert transaction into database!",
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":            "Transaction submitted successfully!",
		"transaction_id":    transactionId,
		"sender_id":         transaction.BKVC.UserID,
		"amount":            transaction.Amount,
		"generation_time":   transaction.TimeStamp,
		"verification_time": verificationTime.Unix(),
	})
}
