package models

// create here your enums...
type MultimediaFor struct {
	Model
	For string `gorm:"not null;unique"`
}

type AuthorType struct {
	Model
	Type string `gorm:"not null;unique"`
}

type FriendRequestStatus struct {
	Model
	Status string `gorm:"not null;unique;size:30"`
}

type UserPrivilege struct {
	Model
	UserID        uint   `gorm:"not null"`
	PrivilegeName string `gorm:"not null;unique;size:40"`
}

type Reaction struct {
	AuthorID uint   `gorm:"primaryKey"`
	PostID   uint   `gorm:"primaryKey"`
	Reaction string `gorm:"size:20;not null"`
}

type Hashtag struct {
	Model
	TagName string `gorm:"not null;unique;size:200"`
}
