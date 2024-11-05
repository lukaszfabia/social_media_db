package models

import (
	"errors"

	"gorm.io/gorm"
)

func (u *User) BeforeSave(tx *gorm.DB) (err error) {
	for _, friend := range u.Friends {
		if friend.AuthorID == u.AuthorID {
			return errors.New("a user cannot add themselves as a friend")
		}
	}
	return
}
