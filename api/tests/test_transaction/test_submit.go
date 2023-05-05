package test_transaction
//
// import (
// 	"bytes"
// 	"encoding/json"
// 	"main/endpoints/auth"
// 	"main/endpoints/transaction"
// 	. "main/tests/helpers"
// 	test "main/tests/helpers"
// 	"net/http"
// 	"testing"
//
// 	"github.com/stretchr/testify/assert"
// )
//
// func TestTransactionSubmit(t *testing.T) {
// 	r, c, w := TestInit()
//
// 	submitController := transaction.SubmitController{}
//
// 	sender := test.CreateRandomVerifiedUser(t, c)
// 	receiver := test.CreateRandomVerifiedUser(t, c)
//
// 	r.POST("/v1/transaction", submitController.Submit)
//   
//   // Create a transaction
//   transaction := test.CreateRandomTransaction(t, c, sender, receiver)
// }
