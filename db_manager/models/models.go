package models

import "gorm.io/gorm"

// create your tables here...

type Author struct {
	gorm.Model
	AuthorTypeID uint       `gorm:"not null"`
	AuthorType   AuthorType `gorm:"foreignKey:ID"`
	Comments     []Comment  `gorm:"foreignKey:AuthorID"`
	Posts        []Post     `gorm:"foreignKey:AuthorID"`
}

type AuthorType struct {
	gorm.Model
	Type string `gorm:"not null;unique"`
}

type User struct {
	gorm.Model
	Username          string              `gorm:"unique;not null;size:50"`
	Email             string              `gorm:"unique;not null;size:100"`
	Password          string              `gorm:"not null"`
	PictureUrl        *string             `gorm:"size:255"`
	BackgroundUrl     *string             `gorm:"size:255"`
	IsVerified        bool                `gorm:"default:false"`
	IsMod             bool                `gorm:"default:false"`
	Bio               string              `gorm:"default:'Edit bio';size:160"`
	ExternalUserLinks []ExternalUserLinks `gorm:"foreignKey:UserID"`
	Friends           []*User             `gorm:"many2many:users_friends"`
	FriendRequests    []FriendRequest     `gorm:"foreignKey:ReceiverID"`

	AuthorID uint
	Author   Author `gorm:"foreignKey:AuthorID"`
}

type ExternalUserLinks struct {
	gorm.Model
	UserID   uint
	Platform string `gorm:"not null;size:60"`
	Link     string `gorm:"not null;size:60"`
}

type Page struct {
	gorm.Model
	AuthorID uint
	Author   Author `gorm:"foreignKey:AuthorID"`

	Title string `gorm:"not null;size:100"`
	Tags  []*Tag `gorm:"many2many:page_tags"`
	Views uint   `gorm:"default:0"`
	Likes uint   `gorm:"default:0"`
}

type Tag struct {
	gorm.Model
	PageID  uint
	TagName string  `gorm:"not null;unique;size:100"`
	Pages   []*Page `gorm:"many2many:page_tags"`
}

type FriendRequest struct {
	gorm.Model
	SenderID   uint `gorm:"not null"`
	ReceiverID uint `gorm:"not null"`
	StatusID   uint `gorm:"not null"`

	Sender   User                `gorm:"foreignKey:SenderID"`
	Receiver User                `gorm:"foreignKey:ReceiverID"`
	Status   FriendRequestStatus `gorm:"foreignKey:StatusID"`
}

type FriendRequestStatus struct {
	gorm.Model
	Status string `gorm:"not null;unique;size:30"`
}

type Comment struct {
	gorm.Model
	AuthorID uint   `gorm:"foreignKey:AuthorID"`
	Content  string `gorm:"not null"`
	// Multimedia []*string
}

type Post struct {
	gorm.Model
	AuthorID uint
	Title    string
	Content  string `gorm:"not null"`
	// Multimedia []*string
	IsPublic bool `gorm:"default:true"`
}

type Multimedia struct {
	//
}

type Location struct {
	gorm.Model
	City       string  `gorm:"size:100"`
	Country    string  `gorm:"size:100"`
	Latitude   float64 `gorm:"not null"`
	Longitude  float64 `gorm:"not null"`
	Address    string  `gorm:"size:255"`
	PostalCode string  `gorm:"size:20"`
}

// type Hashtag struct {
// }

// type Event struct {
// }

// type Reaction struct {
// }

// type Story struct {
// }

// type Reel struct {
// }

// type Message struct {
// }

// type Conversation struct {
// }

// type Group struct {
// }

// type Advertisement struct {
// }
