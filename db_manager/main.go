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

	if err := database.DropTables(); err != nil {
		panic(err)
	} else {
		log.Println("Successfully dropped all the tables")
	}

	// if err := database.CreateEnum("author_type_enum", string(models.PageType), string(models.UserType)); err != nil {
	// 	panic(err)
	// }

	// if err := database.CreateEnum("friend_request_status", string(models.Pending), string(models.Accepted), string(models.Rejected)); err != nil {
	// 	panic(err)
	// }

	if err := database.Sync(); err != nil {
		log.Println("Failed to migrate tables!")
	}
}

func main() {
}
