package data

import (
	"log"
	"main/core"
	"math/rand"
	"time"

	"github.com/google/uuid"
)

type SampleTransaction struct {
	id                uuid.UUID
	sender_id         uuid.UUID
	receiver_id       uuid.UUID
	amount            float32
	generation_time   time.Time
	received_time     time.Time
	verification_time time.Time
}

var SAMPLE_TRANSACTIONS = []SampleTransaction{
	{
		amount:            124.0,
		generation_time:   time.Now().Add(-time.Second * 10),
		received_time:     time.Now().Add(-time.Second * 5),
		verification_time: time.Now(),
	},
	{
		amount:            20.0,
		generation_time:   time.Now().Add(-time.Minute * 7),
		received_time:     time.Now().Add(-time.Minute * 6),
		verification_time: time.Now().Add(-time.Minute * 5),
	},
	{
		amount:            1244.0,
		generation_time:   time.Now().Add(-time.Hour * 7),
		received_time:     time.Now().Add(-time.Hour * 7),
		verification_time: time.Now().Add(-time.Hour * 5),
	},
	{
		amount:            312.0,
		generation_time:   time.Now().Add(-time.Hour * 100),
		received_time:     time.Now().Add(-time.Hour * 100),
		verification_time: time.Now().Add(-time.Minute * 5),
	},
	{
		amount:            452.0,
		generation_time:   time.Now().Add(-time.Minute * 14),
		received_time:     time.Now().Add(-time.Second * 5),
		verification_time: time.Now(),
	},
}

func PopulateTransactions() {
	for idx := range SAMPLE_USERS {
		for transactionIdx := range SAMPLE_TRANSACTIONS {
			var index = rand.Intn(len(SAMPLE_USERS)-1) + 1

			var sender, receiver SampleUser
			if transactionIdx%2 == 0 {
				sender = SAMPLE_USERS[idx]
				receiver = SAMPLE_USERS[(idx+index)%len(SAMPLE_USERS)]
			} else {
				receiver = SAMPLE_USERS[idx]
				sender = SAMPLE_USERS[(idx+index)%len(SAMPLE_USERS)]
			}

			_, err := core.DB.Exec("INSERT INTO Transactions (sender_id, receiver_id, amount, generation_time, received_time, verification_time) VALUES ($1, $2, $3, $4, $5, $6)",
				sender.id,
				receiver.id,
				SAMPLE_TRANSACTIONS[transactionIdx].amount,
				SAMPLE_TRANSACTIONS[transactionIdx].generation_time,
				SAMPLE_TRANSACTIONS[transactionIdx].received_time,
				SAMPLE_TRANSACTIONS[transactionIdx].verification_time,
			)

			log.Printf("Transaction from %s to %s for %f populated!", sender.first_name, receiver.first_name, SAMPLE_TRANSACTIONS[transactionIdx].amount)

			if err != nil {
				log.Println(err)
			}

		}
	}
}
