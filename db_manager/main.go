package main

import (
	"log"
	"social_media/database"

	"github.com/joho/godotenv"
)

func init() {
	if err := godotenv.Load("../.env"); err != nil {
		panic("No .env file")
	}

	database.Connect()

	database.InitializeEnums()

	// if err := database.DropTables(); err != nil {
	// 	panic(err)
	// } else {
	// 	log.Println("Successfully dropped all the tables")
	// }

	if err := database.Sync(); err != nil {
		log.Println("Failed to migrate tables!")
	}
}

func main() {
}
