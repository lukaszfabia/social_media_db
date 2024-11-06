package database

import (
	"log"
	"social_media/models"
)

func InitializeEnums() {
	if err := CreateEnum("author_type_enum", string(models.PageType), string(models.UserType)); err != nil {
		log.Println(err)
	}

	if err := CreateEnum("friend_request_status", string(models.Pending), string(models.Accepted), string(models.Rejected)); err != nil {
		log.Println(err)
	}

	if err := CreateEnum("reaction_type", string(models.Angry), string(models.Haha), string(models.Like), string(models.Love), string(models.Sad), string(models.Wow)); err != nil {
		log.Println(err)
	}
}
