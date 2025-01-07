package database

import (
	"log"
	"social_media/models"
)

var AllModels = []any{
	&models.Author{},
	&models.User{},
	&models.UserPrivilege{},
	&models.ExternalAuthorLink{},
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
	&models.Tag{},
	&models.Advertisement{},
	&models.Group{},
	&models.Reaction{},
	&models.Hashtag{},
	&models.Article{},
	&models.Section{},
}

// register your models
func (s *service) Sync() error {
	for _, model := range AllModels {
		if err := s.db.AutoMigrate(model); err != nil {
			log.Fatalf("Cant migrate model %T, error: %E", model, err)
			return err
		}
	}

	return nil
}
