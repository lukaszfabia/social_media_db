package main

import (
	"fmt"
	"social_media/database"

	"github.com/brianvoe/gofakeit/v6"
	"github.com/joho/godotenv"
)

func init() {
	if err := godotenv.Load("../.env"); err != nil {
		panic("No .env file")
	}

	database.Connect()

	// database.InitializeEnums()

	// if err := database.DropTables(); err != nil {
	// 	panic(err)
	// } else {
	// 	log.Println("Successfully dropped all the tables")
	// }

	// if err := database.Sync(); err != nil {
	// 	log.Println("Failed to migrate tables!")
	// }

	// adding constraints

	// if err := database.Db.Exec("ALTER TABLE friend_requests ADD CONSTRAINT sender_not_receiver CHECK (\"sender_id\" != \"receiver_id\")").Error; err != nil {
	// 	log.Println("Can't create new constraint, maybe already exists")
	// }

	// if err := database.Db.Exec("ALTER TABLE user_friends ADD CONSTRAINT user_cant_have_himself_on_friend_list CHECK (\"user_author_id\" != \"friend_author_id\")").Error; err != nil {
	// 	log.Println("Can't create new constraint, maybe already exists")
	// }
}

func main() {
	// var f *gofakeit.Faker = gofakeit.New(gofakeit.Date().UnixMilli())
	// seeder := seeder.New(database.Db, f)

	// database.ClearTable("user_privileges")
	// seeder.FillPrivileges()

	// var title faker.Title

	for i := 0; i < 10; i++ {
		fmt.Println(gofakeit.Password(true, true, true, true, false, 50))
	}

}
