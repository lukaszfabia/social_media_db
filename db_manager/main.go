package main

import (
	"log"
	"os"
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
		panic("Error with .env file")
	}
	file, err := os.OpenFile("../logs/gorm.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// create new service
	s := database.Connect(file)

	// s.ClearAllTables()
	s.InitEnums()
	s.DropTables()

	if err := s.Sync(); err != nil {
		log.Println("Failed to migrate tables!")
	}

	s.Cook()
}
