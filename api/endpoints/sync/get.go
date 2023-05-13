package sync

import (
	. "main/core"
	. "main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type TransactionRow struct {
	ID                 uuid.UUID `db:"id" json:"id"`
	Signature          string    `db:"signature" json:"signature"`
	SenderTVC          string    `db:"sender_tvc" json:"sender_tvc"`
	ReceiverTVC        string    `db:"receiver_tvc" json:"receiver_tvc"`
	SenderFirstName    string    `db:"sender_first_name" json:"sender_first_name"`
	SenderMiddleName   *string   `db:"sender_middle_name" json:"sender_middle_name"`
	SenderLastName     string    `db:"sender_last_name" json:"sender_last_name"`
	ReceiverFirstName  string    `db:"receiver_first_name" json:"receiver_first_name"`
	ReceiverMiddleName *string   `db:"receiver_middle_name" json:"receiver_middle_name"`
	ReceiverLastName   string    `db:"receiver_last_name" json:"receiver_last_name"`
}

func GetTransactionsById(c *gin.Context, userID uuid.UUID) ([]TransactionRow, error) {
	_, span := Tracer.Start(c.Request.Context(), "GetTransactionsById()")
	defer span.End()
	l := Logger(c).Sugar()

	var transactionHistory, queryErr = DB.Query(`
      SELECT t.id, 
             s.first_name AS sender_first_name, 
             s.middle_name AS sender_middle_name, 
             s.last_name AS sender_last_name, 
             r.first_name AS receiver_first_name, 
             r.middle_name AS receiver_middle_name, 
             r.last_name AS receiver_last_name, 
             t.signature,
             t.sender_tvc, 
             t.receiver_tvc 
      FROM Transactions t 
      JOIN Users s ON t.sender_id = s.id 
      JOIN Users r ON t.receiver_id = r.id 
      WHERE 
        sender_id = $1 OR receiver_id = $1
    `, userID)

	if queryErr != nil {
		l.Errorw("Failed to query transaction history!",
			"error", queryErr,
		)
		return nil, queryErr
	}

	var transactions = []TransactionRow{}

	var err error
	for transactionHistory.Next() {
		var transaction TransactionRow

		err = transactionHistory.Scan(
			&transaction.ID,
			&transaction.SenderFirstName,
			&transaction.SenderMiddleName,
			&transaction.SenderLastName,
			&transaction.ReceiverFirstName,
			&transaction.ReceiverMiddleName,
			&transaction.ReceiverLastName,
			&transaction.Signature,
			&transaction.SenderTVC,
			&transaction.ReceiverTVC,
		)

		if err != nil {
			l.Errorw("Failed to scan transaction!",
				"error", err,
			)
			return nil, err
		}

		transactions = append(transactions, transaction)
	}

	return transactions, nil
}

type TransactionRetrieve struct{}

func (TransactionRetrieve) Retrieve(c *gin.Context) {
	l := Logger(c).Sugar()

	user, err := GetActiveUser(c)

	if err != nil {
		l.Errorw("Failed to get active user!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"msg": "User not logged in!", "context": TraceIDFromContext(c)})
		return
	}

	transactions, err := GetTransactionsById(c, user)

	if err != nil {
		l.Errorw("Failed to get transactions!",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Unknown error occured!", "context": TraceIDFromContext(c)})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"msg":  "success",
		"data": transactions,
	})
}
