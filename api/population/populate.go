package main

import (
	"main/core"
	"main/population/data"
)

func main() {
	core.LoadConfigWithMode("dev")
	core.ConnectDatabase()
	core.ConnectRedis()

	data.PopulateUsers()
	data.PopulateFavorites()
  data.PopulateTransactions()
}
