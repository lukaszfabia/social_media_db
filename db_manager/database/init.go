package database

import "social_media/models"

func InitializeEnums() {
	if err := CreateEnum("author_type_enum", string(models.PageType), string(models.UserType)); err != nil {
		panic(err)
	}

	if err := CreateEnum("friend_request_status", string(models.Pending), string(models.Accepted), string(models.Rejected)); err != nil {
		panic(err)
	}
}
