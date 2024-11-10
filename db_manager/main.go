package main

import (
	"log"
	"social_media/database"

	"github.com/joho/godotenv"
)

// adding constraints

// if err := database.Db.Exec("ALTER TABLE friend_requests ADD CONSTRAINT sender_not_receiver CHECK (\"sender_id\" != \"receiver_id\")").Error; err != nil {
// 	log.Println("Can't create new constraint, maybe already exists")
// }

// if err := database.Db.Exec("ALTER TABLE user_friends ADD CONSTRAINT user_cant_have_himself_on_friend_list CHECK (\"user_author_id\" != \"friend_author_id\")").Error; err != nil {
// 	log.Println("Can't create new constraint, maybe already exists")
// }

func main() {
	if err := godotenv.Load("../.env"); err != nil {
		panic("No .env file")
	}

	// create new service
	s := database.Connect()

	println("Dropping and clearing tables...")

	s.ClearAllTables()
	s.DropTables()

	println("Migrating tables...")

	if err := s.Sync(); err != nil {
		log.Println("Failed to migrate tables!")
	}

	s.Cook()
}
