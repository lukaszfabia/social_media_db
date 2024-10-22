package database

import (
	"social_media/models"
)

// register your models
func Sync() error {

	return Db.AutoMigrate(
		&models.Advertisement{},
		&models.Author{},
		&models.AuthorType{},
		&models.Comment{},
		// &models.Conversation{},
		&models.Event{},
		&models.ExternalUserLinks{},
		&models.FriendRequest{},
		&models.FriendRequestStatus{},
		&models.Hashtag{},
		&models.Location{},
		// &models.Message{},
		// &models.Multimedia{},
		// &models.MultimediaFor{},
		&models.Page{},
		&models.Post{},
		&models.Reaction{},
		&models.Reel{},
		&models.Tag{},
		&models.User{},
		&models.UserPrivilege{},
	)
}
