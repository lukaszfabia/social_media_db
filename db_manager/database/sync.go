package database

import (
	"log"
	"social_media/models"
)

var AllModels = []any{
	&models.Author{},
	&models.User{},
	&models.UserPrivilege{},
	&models.ExternalUserLinks{},
	&models.Tag{},
	&models.FriendRequest{},
	&models.Comment{},
	&models.Post{},
	&models.Location{},
	&models.Geolocation{},
	&models.Address{},
	&models.Event{},
	&models.Reel{},
	&models.Message{},
	&models.Conversation{},
	&models.Page{},
	&models.Advertisement{},
	&models.Group{},
	&models.Reaction{},
	&models.Hashtag{},
}

// register your models
func Sync() error {
	for _, model := range AllModels {
		if err := Db.AutoMigrate(model); err != nil {
			log.Fatalf("Cant migrate model %T", model)
			return err
		}
	}

	return nil
}
