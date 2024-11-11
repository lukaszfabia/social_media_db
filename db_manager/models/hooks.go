package models

import (
	"errors"
	"log"

	"gorm.io/gorm"
)

func (u *User) BeforeSave(tx *gorm.DB) (err error) {

	for _, friend := range u.Friends {
		if friend.AuthorID == u.AuthorID {
			return errors.New("a user cannot add themselves as a friend")
		}
	}

	return nil
}

func (f *FriendRequest) BeforeCreate(tx *gorm.DB) (err error) {

	if f.SenderID == f.ReceiverID {
		return errors.New("cant be in friendship with himself")
	}

	// check if the friend request already exists
	var existingRequest FriendRequest
	if err := tx.Where("sender_id = ? AND receiver_id = ?", f.SenderID, f.ReceiverID).
		Or("sender_id = ? AND receiver_id = ?", f.ReceiverID, f.SenderID).
		First(&existingRequest).Error; err == nil {

		log.Printf("Friend request between %d and %d already exists\n", f.SenderID, f.ReceiverID)
		return errors.New("friend request already exists")
	}
	return nil
}
