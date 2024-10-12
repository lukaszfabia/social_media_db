package database

import (
	"social_media/models"
)

func Sync() error {
	// register your models
	return Db.AutoMigrate(&models.User{})
}
