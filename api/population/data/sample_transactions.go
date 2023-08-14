package data

import (
	"context"
	"crypto/ed25519"
	"encoding/base64"
	"log"
	"main/core"
	"main/payloads"
	population "main/population/helpers"
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
	verification_time time.Time
}

var SAMPLE_TRANSACTIONS = []SampleTransaction{
	{
		amount:            124.0,
		generation_time:   time.Now().Add(-time.Second * 10),
		verification_time: time.Now(),
	},
	{
		amount:            20.0,
		generation_time:   time.Now().Add(-time.Minute * 7),
		verification_time: time.Now().Add(-time.Minute * 5),
	},
	{
		amount:            1244.0,
		generation_time:   time.Now().Add(-time.Hour * 7),
		verification_time: time.Now().Add(-time.Hour * 5),
	},
	{
		amount:            312.0,
		generation_time:   time.Now().Add(-time.Hour * 100),
		verification_time: time.Now().Add(-time.Minute * 5),
	},
	{
		amount:            452.0,
		generation_time:   time.Now().Add(-time.Minute * 14),
		verification_time: time.Now(),
	},
}

func PopulateTransactions() {
	_, c, _ := population.PopulationInit()

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

			pubKey, privKey, _ := ed25519.GenerateKey(nil)

			sampleSenderBKVC := payloads.BalanceKeyVerificationCertificate{
				UserID:           sender.id,
				AvailableBalance: 15000,
				PublicKey:        [32]byte(pubKey),
				TimeStamp:        time.Now(),
			}

			sampleSenderBKVC.Sign(c)

			sampleReceiverBKVC := payloads.BalanceKeyVerificationCertificate{
				UserID:           receiver.id,
				AvailableBalance: 15000,
				PublicKey:        [32]byte(pubKey),
				TimeStamp:        time.Now(),
			}

			sampleSenderBKVC.Sign(c)

			sampleTransaction := payloads.TransactionAuthorizationMessage{
				Amount:    SAMPLE_TRANSACTIONS[transactionIdx].amount,
				To:        receiver.id,
				BKVC:      sampleSenderBKVC,
				TimeStamp: SAMPLE_TRANSACTIONS[transactionIdx].generation_time,
			}
			sampleTransaction.Sign(c, privKey)

			sampleSenderTVC := payloads.TransactionVerificationCertificate{
				Amount:    SAMPLE_TRANSACTIONS[transactionIdx].amount,
				From:      receiver.id,
				BKVC:      sampleSenderBKVC,
				TimeStamp: SAMPLE_TRANSACTIONS[transactionIdx].generation_time,
			}

			sampleReceiverTVC := payloads.TransactionVerificationCertificate{
				Amount:    SAMPLE_TRANSACTIONS[transactionIdx].amount,
				From:      receiver.id,
				BKVC:      sampleReceiverBKVC,
				TimeStamp: SAMPLE_TRANSACTIONS[transactionIdx].generation_time,
			}

			sampleSenderTVC.Sign(c)
			sampleReceiverTVC.Sign(c)

			// Print populated transaction data
			log.Printf("Transaction from %s to %s for %f generated!", sender.first_name, receiver.first_name, SAMPLE_TRANSACTIONS[transactionIdx].amount)

			_, err := core.DB.Exec(context.Background(), "INSERT INTO Transactions (sender_id, receiver_id, amount, generation_time, verification_time, sender_tvc, receiver_tvc, signature) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
				sender.id,
				receiver.id,
				SAMPLE_TRANSACTIONS[transactionIdx].amount,
				SAMPLE_TRANSACTIONS[transactionIdx].generation_time,
				SAMPLE_TRANSACTIONS[transactionIdx].verification_time,
				base64.StdEncoding.EncodeToString(sampleSenderTVC.ToBytes(c)),
				base64.StdEncoding.EncodeToString(sampleReceiverTVC.ToBytes(c)),
				base64.StdEncoding.EncodeToString(sampleTransaction.Signature[:]),
			)

			if err != nil {
				log.Println(err)
			}
		}
	}
}
