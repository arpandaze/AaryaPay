package transaction

import (
	"database/sql"
	"encoding/base64"
	"main/core"
	. "main/payloads"
	. "main/telemetry"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type SubmitResponse struct {
	Message     string  `json:"message"`
	Success     bool    `json:"success"`
	SenderTVC   *string `json:"sender_tvc,omitempty"`
	ReceiverTVC *string `json:"receiver_tvc,omitempty"`
	Signature   string  `json:"signature"`
}

type SubmitController struct{}

func (SubmitController) Submit(c *gin.Context) {
	l := Logger(c).Sugar()

	var transactionSubmitForm struct {
		EncodedTransaction []string `form:"transactions"`
	}

	if err := c.Bind(&transactionSubmitForm); err != nil {
		msg := "Invalid request payload on transaction submission!"

		l.Errorw(msg,
			"error", err,
		)

		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	if len(transactionSubmitForm.EncodedTransaction) == 0 {
		msg := "No transactions to submit!"
		l.Errorw(msg)
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg, "context": TraceIDFromContext(c)})
		return
	}

	var responses []SubmitResponse
	var hasError bool

	for _, encodedTransaction := range transactionSubmitForm.EncodedTransaction {
		transactionsBytes, err := base64.RawStdEncoding.DecodeString(encodedTransaction)

		if err != nil {
			l.Errorw("Failed to decode base64 transaction!",
				"error", err,
			)

			hasError = true

			responses = append(responses, SubmitResponse{
				Message: "Unknown error occurred!",
				Success: false,
			})

			continue
		}

		transaction, err := TransactionFromBytes(c, transactionsBytes)
		if err != nil {
			l.Errorw("Failed to construct transaction from bytes!",
				"error", err,
			)

			hasError = true

			responses = append(responses, SubmitResponse{
				Message: "Unknown error occurred!",
				Success: false,
			})

			continue
		}

		timeLimit := int64(core.Configs.KEY_VALIDITY_TIME_HOURS) * 60 * 60

		if transaction.TimeStamp.Unix() < time.Now().Unix()-timeLimit {
			msg := "Transaction is too old!"

			l.Errorw(msg,
				"error", err,
				"transaction", transactionSubmitForm.EncodedTransaction,
			)

			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Transaction is too old!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		validTransaction := transaction.Verify(c)

		if !validTransaction {
			l.Errorw("Failed to verify transaction!",
				"transaction", transactionSubmitForm.EncodedTransaction,
				"error", err)

			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Failed to verify transaction!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		validBKVC := transaction.BKVC.Verify(c)
		if !validBKVC {
			l.Errorw("Failed to verify BKVC in transaction!",
				"transaction", transactionSubmitForm.EncodedTransaction,
				"error", err)

			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Failed to verify BKVC in transaction!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		tx, err := core.DB.Begin()
		if err != nil {
			msg := "Failed to start transaction"
			l.Errorw(msg,
				"error", err,
			)

			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		var transactionId uuid.UUID
		var verificationTime time.Time
		var existingSenderTVC, existingReceiverTVC string

		err = tx.QueryRow("SELECT id, verification_time, sender_tvc, receiver_tvc FROM Transactions WHERE signature = $1", base64.StdEncoding.EncodeToString(transaction.Signature[:])).Scan(&transactionId, &verificationTime, existingSenderTVC, existingReceiverTVC)

		if err == nil {
			tx.Rollback()

			responses = append(responses, SubmitResponse{
				Message:     "Transaction already submitted",
				SenderTVC:   &existingSenderTVC,
				ReceiverTVC: &existingReceiverTVC,
				Success:     true,
			})

			continue

		} else if err != sql.ErrNoRows {
			l.Errorw("Failed to query transaction table",
				"error", err,
			)
			tx.Rollback()
			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		err = tx.QueryRow("INSERT INTO Transactions (sender_id, receiver_id, amount, generation_time, signature) VALUES ($1, $2, $3, $4, $5) RETURNING id, verification_time",
			transaction.BKVC.UserID, transaction.To, transaction.Amount, transaction.TimeStamp, base64.StdEncoding.EncodeToString(transaction.Signature[:]),
		).Scan(&transactionId, &verificationTime)

		if err != nil {
			l.Errorw("Failed to insert transaction into database!",
				"error", err,
			)

			tx.Rollback()
			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		_, err = tx.Exec("UPDATE Accounts SET balance = balance - $1 WHERE id = $2", transaction.Amount, transaction.BKVC.UserID)

		if err != nil {
			l.Errorw("Failed to update sender balance!",
				"error", err,
			)
			tx.Rollback()
			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		_, err = tx.Exec("UPDATE Accounts SET balance = balance + $1 WHERE id = $2", transaction.Amount, transaction.To)

		if err != nil {
			l.Errorw("Failed to update receiver balance!",
				"error", err,
			)
			tx.Rollback()
			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
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
			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		senderPublicKey := senderKeyPairBytes[32:]

		senderBKVC := BalanceKeyVerificationCertificate{
			MessageType:      BKVCMessageType,
			UserID:           transaction.BKVC.UserID,
			AvailableBalance: SenderAvailableBalance,
			PublicKey:        [32]byte(senderPublicKey),
			TimeStamp:        SenderUpdatedTime,
		}

		senderBKVC.Sign(c)

		senderTVC := TransactionVerificationCertificate{
			MessageType:          TVCMessageType,
			TransactionSignature: transaction.Signature,
			TransactionID:        transactionId,
			BKVC:                 senderBKVC,
		}

		senderTVC.Sign(c)

		var ReceiverAvailableBalance float32
		var ReceiverPublicKey string
		var ReceiverUpdatedTime time.Time

		err = tx.QueryRow(`
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
			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		receiverPublicKey := receiverKeyPairBytes[32:]

		receiverBKVC := BalanceKeyVerificationCertificate{
			MessageType:      BKVCMessageType,
			UserID:           transaction.To,
			AvailableBalance: ReceiverAvailableBalance,
			PublicKey:        [32]byte(receiverPublicKey),
			TimeStamp:        ReceiverUpdatedTime,
		}

		receiverTVC := TransactionVerificationCertificate{
			MessageType:          TVCMessageType,
			TransactionSignature: transaction.Signature,
			TransactionID:        transactionId,
			BKVC:                 receiverBKVC,
		}

		receiverTVC.Sign(c)

		senderTVCBase64 := base64.StdEncoding.EncodeToString(senderTVC.ToBytes(c))
		receiverTVCBase64 := base64.StdEncoding.EncodeToString(receiverTVC.ToBytes(c))

		_, err = tx.Exec("UPDATE Transactions SET sender_tvc = $1, receiver_tvc = $2 WHERE id = $3", senderTVCBase64, receiverTVCBase64, transactionId)

		if err != nil {
			l.Errorw("Failed to update transaction signatures!",
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
			return
		}

		err = tx.Commit()

		if err != nil {
			l.Errorw("Failed to commit transaction!",
				"error", err,
			)
			hasError = true

			responses = append(responses, SubmitResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			})

			continue
		}

		responses = append(responses, SubmitResponse{
			Message:     "Transaction submitted successfully!",
			SenderTVC:   &senderTVCBase64,
			ReceiverTVC: &receiverTVCBase64,
			Signature:   base64.StdEncoding.EncodeToString(transaction.Signature[:]),
			Success:     true,
		})
	}

	if !hasError {
		c.JSON(http.StatusAccepted, gin.H{
			"message":   "Transactions submitted successfully!",
			"success":   true,
			"responses": responses,
		})
	} else {
		c.JSON(http.StatusMultiStatus, gin.H{
			"message":   "Not all transactions were submitted successfully!",
			"context":   TraceIDFromContext(c),
			"success":   false,
			"responses": responses,
		})
	}
}
