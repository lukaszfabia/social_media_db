package database

import (
	"social_media/models"
)

// register your models
func Sync() error {
	return Db.AutoMigrate(
		&models.Author{},
		&models.AuthorType{},
		&models.User{},
		&models.ExternalUserLinks{},
		&models.Page{},
		&models.Tag{},
		&models.FriendRequest{},
		&models.FriendRequestStatus{},
		&models.Location{},
		&models.Comment{},
		&models.Post{},
	)
}
