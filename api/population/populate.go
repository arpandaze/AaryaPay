package main

import (
	"main/core"
	"main/population/data"
)

func main() {
	core.LoadConfig("dev")
	core.ConnectDatabase()
	core.ConnectRedis()

	data.PopulateUsers()
	data.PopulateFavorites()
}
