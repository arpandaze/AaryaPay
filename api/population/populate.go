package main

import (
	"main/core"
	"main/population/data"
)

func Populate() {
	data.PopulateUsers()
	data.PopulateFavorites()
	data.PopulateTransactions()
}

func main() {
	core.LoadConfig()
	core.ConnectDatabase()

	Populate()
}
