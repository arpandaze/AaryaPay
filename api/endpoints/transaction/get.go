package transaction

import (
	. "main/core"
	. "main/telemetry"
	"main/utils"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type TransactionRow struct {
	ID               uuid.UUID            `db:"id" json:"id"`
	SenderID         uuid.UUID            `db:"sender_id" json:"sender_id"`
	ReceiverID       uuid.UUID            `db:"receiver_id" json:"receiver_id"`
	Amount           float32              `db:"amount" json:"amount"`
	GenerationTime   *utils.UnixTimestamp `db:"generation_time" json:"generation_time"`
	VerificationTime *utils.UnixTimestamp `db:"verification_time" json:"verification_time"`
	Signature        string               `db:"signature" json:"signature"`
	SenderTVC        string               `db:"sender_tvc" json:"sender_tvc"`
	ReceiverTVC      string               `db:"receiver_tvc" json:"receiver_tvc"`
}

type TransactionRetrieve struct{}

func (TransactionRetrieve) Retrieve(c *gin.Context) {
	l := Logger(c).Sugar()

	user, err := GetActiveUser(c)

	if err != nil {
		l.Errorw("Failed to get active user!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "User not logged in!", "context": TraceIDFromContext(c)})
		return
	}

	var transactionHistory, queryErr = DB.Query(`
    SELECT 
      id, 
      sender_id, 
      receiver_id, 
      amount, 
      generation_time, 
      verification_time, 
      signature, 
      sender_tvc, 
      receiver_tvc 
    FROM 
      Transactions 
    WHERE 
      sender_id = $1 OR receiver_id = $1
    `, user)

	if queryErr != nil {
		l.Errorw("Failed to query transaction history!",
			"error", queryErr,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	var transactions = []TransactionRow{}

	for transactionHistory.Next() {
		var transaction TransactionRow

		err = transactionHistory.Scan(&transaction.ID, &transaction.SenderID, &transaction.ReceiverID, &transaction.Amount, &transaction.GenerationTime, &transaction.VerificationTime, &transaction.Signature, &transaction.SenderTVC, &transaction.ReceiverTVC)

		if err != nil {
			l.Errorw("Failed to scan transaction!",
				"error", err,
			)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
			return
		}

		transactions = append(transactions, transaction)
	}

	c.JSON(http.StatusOK, gin.H{
		"msg":  "success",
		"data": transactions,
	})
}
