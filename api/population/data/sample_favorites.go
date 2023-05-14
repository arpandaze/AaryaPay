package data

import (
	"context"
	"log"
	"main/core"
)

func PopulateFavorites() {
	for index, user := range SAMPLE_USERS {
		for i := 1; i < 6; i++ {
			nextUser := SAMPLE_USERS[(index+i)%len(SAMPLE_USERS)]

			query := `
        INSERT INTO Favorites
        (
          favorite_owner,
          favorite_account
        )
        VALUES
        (
          $1,
          $2
        )
      `
			_, err := core.DB.Exec(context.Background(), query, user.id, nextUser.id)
			if err != nil {
				msg := "Failed to execute SQL statement"
				log.Printf(msg)
				log.Fatal(err)
				return
			}

			log.Printf("Inserted %s as favorite for %s", nextUser.first_name+" "+nextUser.last_name, user.first_name+" "+user.last_name)
		}
	}
}
