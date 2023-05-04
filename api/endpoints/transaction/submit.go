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
		EncodedTransaction string `form:"transaction"`
	}

	if err := c.Bind(&transactionSubmitForm); err != nil {
		msg := "Invalid request payload on transaction submission!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	transactionsBytes, err := base64.RawStdEncoding.DecodeString(transactionSubmitForm.EncodedTransaction)

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
			"transaction", transactionSubmitForm.EncodedTransaction,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	validTransaction := transaction.Verify(c)

	if !validTransaction {
		msg := "Invalid transaction!"

		l.Errorw("Failed to verify transaction!",
			"transaction", transactionSubmitForm.EncodedTransaction,
			"error", err)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	if transaction.BKVC.Verify(c) {
		msg := "Invalid transaction!"

		l.Errorw("Failed to verify BKVC in transaction!",
			"transaction", transactionSubmitForm.EncodedTransaction,
			"error", err)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	tx, err := core.DB.Begin()
	if err != nil {
		msg := "Failed to start transaction"
		l.Errorw(msg,
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	var transactionId uuid.UUID
	var verificationTime time.Time
	err = tx.QueryRow("INSERT INTO Transactions (sender_id, receiver_id, amount, generation_time) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id, verification_time",
		transaction.BKVC.UserID, transaction.To, transaction.Amount, transaction.TimeStamp, time.Now(),
	).Scan(&transactionId, &verificationTime)

	if err != nil {
		l.Errorw("Failed to insert transaction into database!",
			"error", err,
		)

		tx.Rollback()
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	_, err = tx.Exec("UPDATE Accounts SET balance = balance - $1 WHERE id = $2", transaction.Amount, transaction.BKVC.UserID)

	if err != nil {
		l.Errorw("Failed to update sender balance!",
			"error", err,
		)
		tx.Rollback()
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
	}

	_, err = tx.Exec("UPDATE Accounts SET balance = balance + $1 WHERE id = $2", transaction.Amount, transaction.To)

	if err != nil {
		l.Errorw("Failed to update receiver balance!",
			"error", err,
		)
		tx.Rollback()
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
	}

	err = tx.Commit()

	if err != nil {
		l.Errorw("Failed to commit transaction!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
	}

	var SenderAvailableBalance float32
	var SenderPublicKey string
	var SenderUpdatedTime time.Time

	err = tx.QueryRow(`
      SELECT a.balance, k.value, NOW()
      FROM Users u
      JOIN Accounts a ON u.id = a.id
      JOIN Keys k ON u.id = k.associated_user AND k.active = TRUE
      WHERE u.id = $1
    `, transaction.BKVC.UserID).Scan(&SenderAvailableBalance, &SenderPublicKey, &SenderUpdatedTime)

	senderKeyPairBytes, err := base64.StdEncoding.DecodeString(SenderPublicKey)

	if err != nil {
		l.Errorw("Failed to decode base64 public key!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	senderPublicKey := senderKeyPairBytes[32:]

	senderBKVC := core.BalanceKeyVerificationCertificate{
		MessageType:      core.BKVCMessageType,
		UserID:           transaction.BKVC.UserID,
		AvailableBalance: SenderAvailableBalance,
		PublicKey:        [32]byte(senderPublicKey),
		TimeStamp:        SenderUpdatedTime,
	}

	senderBKVC.Sign(c)

	senderTKVC := core.TransactionVerificationCertificate{
		MessageType:          core.TVCMessageType,
		TransactionSignature: transaction.Signature,
		TransactionID:        transactionId,
		BKVC:                 senderBKVC,
	}

	senderTKVC.Sign(c)

	var ReceiverAvailableBalance float32
	var ReceiverPublicKey string
	var ReceiverUpdatedTime time.Time

	err = core.DB.QueryRow(`
      SELECT a.balance, k.value, NOW()
      FROM Users u
      JOIN Accounts a ON u.id = a.id
      JOIN Keys k ON u.id = k.associated_user AND k.active = TRUE
      WHERE u.id = $1
    `, transaction.To).Scan(&ReceiverAvailableBalance, &ReceiverPublicKey, &ReceiverUpdatedTime)

	receiverKeyPairBytes, err := base64.StdEncoding.DecodeString(ReceiverPublicKey)

	if err != nil {
		l.Errorw("Failed to decode base64 public key!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	receiverPublicKey := receiverKeyPairBytes[32:]

	receiverBKVC := core.BalanceKeyVerificationCertificate{
		MessageType:      core.BKVCMessageType,
		UserID:           transaction.To,
		AvailableBalance: ReceiverAvailableBalance,
		PublicKey:        [32]byte(receiverPublicKey),
		TimeStamp:        ReceiverUpdatedTime,
	}

	receiverTKVC := core.TransactionVerificationCertificate{
		MessageType:          core.TVCMessageType,
		TransactionSignature: transaction.Signature,
		TransactionID:        transactionId,
		BKVC:                 receiverBKVC,
	}

	receiverTKVC.Sign(c)

	c.JSON(http.StatusOK, gin.H{
		"status":       "Transaction submitted successfully!",
		"sender_tvc":   base64.StdEncoding.EncodeToString(senderTKVC.ToBytes(c)),
		"receiver_tvc": base64.StdEncoding.EncodeToString(receiverTKVC.ToBytes(c)),
	})
}
