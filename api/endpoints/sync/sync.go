package sync

import (
	"database/sql"
	"encoding/base64"
	"main/core"
	"main/endpoints/favorites"
	"main/endpoints/profile"
	. "main/payloads"
	. "main/telemetry"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type SyncResponse struct {
	SubmissionStatus gin.H                    `json:"submission_status,omitempty"`
	Success          bool                     `json:"success"`
	Message          string                   `json:"message"`
	Favorite         []favorites.FavoriteUser `json:"favorites"`
	Transaction      []TransactionRow         `json:"transactions,omitempty"`
	Profile          profile.ProfileData      `json:"profile"`
	BKVC             *string                  `json:"bkvc,omitempty"`
	Context          *string                  `json:"context,omitempty"`
}

type TransactionSubmissionResponse struct {
	Message            string     `json:"message"`
	Success            bool       `json:"success"`
	ID                 *uuid.UUID `json:"transaction_id,omitempty"`
	SenderFirstName    *string    `json:"sender_first_name,omitempty"`
	SenderMiddleName   *string    `json:"sender_middle_name,omitempty"`
	SenderLastName     *string    `json:"sender_last_name,omitempty"`
	ReceiverFirstName  *string    `json:"receiver_first_name,omitempty"`
	ReceiverMiddleName *string    `json:"receiver_middle_name,omitempty"`
	ReceiverLastName   *string    `json:"receiver_last_name,omitempty"`
	SenderTVC          *string    `json:"sender_tvc,omitempty"`
	ReceiverTVC        *string    `json:"receiver_tvc,omitempty"`
	Signature          *string    `json:"signature,omitempty"`
}

type SyncController struct{}

func (SyncController) Sync(c *gin.Context) {
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

	var responses []TransactionSubmissionResponse
	var hasError bool

	for _, encodedTransaction := range transactionSubmitForm.EncodedTransaction {
		transactionsBytes, err := base64.RawStdEncoding.DecodeString(encodedTransaction)

		if err != nil {
			l.Errorw("Failed to decode base64 transaction!",
				"error", err,
			)

			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message: "Unknown error occurred!",
				Success: false,
			})

			continue
		}

		transaction, err := TAMFromBytes(c, transactionsBytes)
		if err != nil {
			l.Errorw("Failed to construct transaction from bytes!",
				"error", err,
			)

			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message: "Unknown error occurred!",
				Success: false,
			})

			continue
		}

		signature := base64.StdEncoding.EncodeToString(transaction.Signature[:])

		timeLimit := int64(core.Configs.KEY_VALIDITY_TIME_HOURS) * 60 * 60

		if transaction.TimeStamp.Unix() < time.Now().Unix()-timeLimit {
			msg := "Transaction is too old!"

			l.Errorw(msg,
				"error", err,
				"transaction", transactionSubmitForm.EncodedTransaction,
			)

			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Transaction is too old!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		validTransaction := transaction.Verify(c)

		if !validTransaction {
			l.Errorw("Failed to verify transaction!",
				"transaction", transactionSubmitForm.EncodedTransaction,
				"error", err)

			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Failed to verify transaction!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		validBKVC := transaction.BKVC.Verify(c)
		if !validBKVC {
			l.Errorw("Failed to verify BKVC in transaction!",
				"transaction", transactionSubmitForm.EncodedTransaction,
				"error", err)

			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Failed to verify BKVC in transaction!",
				Success:   false,
				Signature: &signature,
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

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		var transactionId uuid.UUID
		var verificationTime time.Time
		var existingSenderTVC, existingReceiverTVC string

		var senderId uuid.UUID
		var senderFirstName string
		var senderMiddleName *string
		var senderLastName string

		var receiverId uuid.UUID
		var receiverFirstName string
		var receiverMiddleName *string
		var receiverLastName string

		err = tx.QueryRow(`
      SELECT t.id, 
             t.sender_id, 
             s.first_name AS sender_first_name, 
             s.middle_name AS sender_middle_name, 
             s.last_name AS sender_last_name, 
             t.receiver_id, 
             r.first_name AS receiver_first_name, 
             r.middle_name AS receiver_middle_name, 
             r.last_name AS receiver_last_name, 
             t.verification_time, 
             t.sender_tvc, 
             t.receiver_tvc 
      FROM Transactions t 
      JOIN Users s ON t.sender_id = s.id 
      JOIN Users r ON t.receiver_id = r.id 
      WHERE t.signature = $1`,
			signature,
		).Scan(&transactionId, &senderId, &senderFirstName, &senderMiddleName, &senderLastName, &receiverId, &receiverFirstName, &receiverMiddleName, &receiverLastName, &verificationTime, &existingSenderTVC, &existingReceiverTVC)

		if err == nil {
			tx.Rollback()

			responses = append(responses, TransactionSubmissionResponse{
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

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		err = tx.QueryRow("INSERT INTO Transactions (sender_id, receiver_id, amount, generation_time, signature) VALUES ($1, $2, $3, $4, $5) RETURNING id, verification_time",
			transaction.BKVC.UserID, transaction.To, transaction.Amount, transaction.TimeStamp, signature,
		).Scan(&transactionId, &verificationTime)

		if err != nil {
			l.Errorw("Failed to insert transaction into database!",
				"error", err,
			)

			tx.Rollback()
			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
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

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
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

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		var SenderAvailableBalance float32
		var SenderPublicKey string
		var SenderUpdatedTime time.Time

		err = tx.QueryRow(`
      SELECT a.balance, k.value, u.first_name, u.middle_name, u.last_name, NOW()
      FROM Users u
      JOIN Accounts a ON u.id = a.id
      JOIN Keys k ON u.id = k.associated_user AND k.active = TRUE
      WHERE u.id = $1;
    `, transaction.BKVC.UserID).Scan(&SenderAvailableBalance, &SenderPublicKey, &senderFirstName, &senderMiddleName, &senderLastName, &SenderUpdatedTime)

		senderKeyPairBytes, err := base64.StdEncoding.DecodeString(SenderPublicKey)

		if err != nil {
			l.Errorw("Failed to decode base64 public key!",
				"error", err,
			)
			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
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
			MessageType: TVCMessageType,
			Amount:      transaction.Amount,
			From:        transaction.BKVC.UserID,
			TimeStamp:   transaction.TimeStamp,
			BKVC:        senderBKVC,
		}

		senderTVC.Sign(c)

		var receiverAvailableBalance float32
		var ReceiverPublicKey string
		var ReceiverUpdatedTime time.Time

		err = tx.QueryRow(`
      SELECT a.balance, k.value, u.first_name, u.middle_name, u.last_name, NOW()
      FROM Users u
      JOIN Accounts a ON u.id = a.id
      JOIN Keys k ON u.id = k.associated_user AND k.active = TRUE
      WHERE u.id = $1
    `, transaction.To).Scan(&receiverAvailableBalance, &ReceiverPublicKey, &receiverFirstName, &receiverMiddleName, &receiverLastName, &ReceiverUpdatedTime)

		if err != nil {
			l.Errorw("Receiver account is inactive!",
				"error", err,
			)

			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Receiver account is inactive!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		receiverKeyPairBytes, err := base64.StdEncoding.DecodeString(ReceiverPublicKey)

		if err != nil {
			l.Errorw("Failed to decode base64 public key!",
				"error", err,
			)
			hasError = true

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		receiverPublicKey := receiverKeyPairBytes[32:]

		receiverBKVC := BalanceKeyVerificationCertificate{
			MessageType:      BKVCMessageType,
			UserID:           transaction.To,
			AvailableBalance: receiverAvailableBalance,
			PublicKey:        [32]byte(receiverPublicKey),
			TimeStamp:        ReceiverUpdatedTime,
		}

		receiverTVC := TransactionVerificationCertificate{
			MessageType: TVCMessageType,
			Amount:      transaction.Amount,
			From:        transaction.BKVC.UserID,
			TimeStamp:   transaction.TimeStamp,
			BKVC:        receiverBKVC,
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

			responses = append(responses, TransactionSubmissionResponse{
				Message:   "Unknown error occurred!",
				Success:   false,
				Signature: &signature,
			})

			continue
		}

		responses = append(responses, TransactionSubmissionResponse{
			Message:            "Transaction submitted successfully!",
			SenderFirstName:    &senderFirstName,
			SenderMiddleName:   senderMiddleName,
			SenderLastName:     &senderLastName,
			ReceiverFirstName:  &receiverFirstName,
			ReceiverMiddleName: receiverMiddleName,
			ReceiverLastName:   &receiverLastName,
			SenderTVC:          &senderTVCBase64,
			ReceiverTVC:        &receiverTVCBase64,
			Signature:          &signature,
			Success:            true,
		})
	}

	var returnStatusCode int
	if hasError {
		returnStatusCode = http.StatusMultiStatus
	} else {
		returnStatusCode = http.StatusAccepted
	}

	var transactionSubmissionStatus gin.H

	if len(transactionSubmitForm.EncodedTransaction) == 0 {
		transactionSubmissionStatus = nil
	} else if !hasError {
		transactionSubmissionStatus = gin.H{
			"message":   "Transactions submitted successfully!",
			"success":   true,
			"responses": responses,
		}
	} else {
		transactionSubmissionStatus = gin.H{
			"message":   "Not all transactions were submitted successfully!",
			"context":   TraceIDFromContext(c),
			"success":   false,
			"responses": responses,
		}
	}

	user, err := core.GetActiveUser(c)

	if err != nil {
		c.JSON(returnStatusCode, gin.H{
			"submission_status": transactionSubmissionStatus,
		})
	} else {
		var userBKVC BalanceKeyVerificationCertificate

		var profileDataReturn profile.ProfileData

		var userKeyPairBase64 string
		var updatedTime time.Time
		err = core.DB.QueryRow(`
      SELECT a.balance, k.value, u.id, u.first_name, u.middle_name, u.last_name, u.photo_url, u.dob, u.email, NOW()
      FROM Users u
      JOIN Accounts a ON u.id = a.id
      JOIN Keys k ON u.id = k.associated_user AND k.active = TRUE
      WHERE u.id = $1;
    `, user).Scan(&userBKVC.AvailableBalance, &userKeyPairBase64, &profileDataReturn.Id, &profileDataReturn.FirstName, &profileDataReturn.MiddleName, &profileDataReturn.LastName, &profileDataReturn.PhotoUrl, &profileDataReturn.DOB, &profileDataReturn.Email, &updatedTime)

		if err != nil {
			l.Errorw("Failed to get user details!",
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
			return
		}

		userKeyPairBytes, err := base64.StdEncoding.DecodeString(userKeyPairBase64)

		if err != nil {
			l.Errorw("Failed to decode base64 public key!",
				"error", err,
			)

			c.AbortWithStatusJSON(http.StatusMultiStatus, gin.H{
				"message":           "Unknown error occurred!",
				"success":           false,
				"submission_status": transactionSubmissionStatus,
				"context":           TraceIDFromContext(c),
			})
			return
		}

		userPublicKey := userKeyPairBytes[32:]

		userBKVC.UserID = user
		userBKVC.PublicKey = [32]byte(userPublicKey)
		userBKVC.TimeStamp = updatedTime

		userBKVC.Sign(c)

		bkvcBase64 := base64.StdEncoding.EncodeToString(userBKVC.ToBytes(c))

		l.Infow("Successfully synced!",
			"user", user,
		)

		favoriteUsers, err := favorites.GetFavoritesById(c, user)

		if err != nil {
			l.Errorw("Failed to get favorites!",
				"error", err,
			)

			contextId := TraceIDFromContext(c)

			c.AbortWithStatusJSON(http.StatusMultiStatus,
				SyncResponse{
					Message:          "Unknown error occurred!",
					Success:          false,
					SubmissionStatus: transactionSubmissionStatus,
					Context:          &contextId,
					BKVC:             &bkvcBase64,
					Profile:          profileDataReturn,
				},
			)
			return
		}

		transactionHistory, err := GetTransactionsById(c, user)

		if err != nil {
			l.Errorw("Failed to get transaction history!",
				"error", err,
			)

			contextId := TraceIDFromContext(c)
			c.AbortWithStatusJSON(http.StatusMultiStatus,
				SyncResponse{
					Message:          "Unknown error occurred!",
					Success:          false,
					SubmissionStatus: transactionSubmissionStatus,
					Context:          &contextId,
					BKVC:             &bkvcBase64,
					Favorite:         favoriteUsers,
					Profile:          profileDataReturn,
				},
			)
			return
		}

		c.JSON(returnStatusCode, SyncResponse{
			Message:          "Successfully synced!",
			Success:          true,
			SubmissionStatus: transactionSubmissionStatus,
			BKVC:             &bkvcBase64,
			Profile:          profileDataReturn,
			Favorite:         favoriteUsers,
			Transaction:      transactionHistory,
		})
	}
}
