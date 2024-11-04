package models

import "time"

// create your tables here...

// add deleting conditions
type Author struct {
	Model
	AuthorType AuthorType 'gorm:"text; not null"'
	
	Comments     []Comment  `gorm:"foreignKey:AuthorID"`
	Posts        []Post     `gorm:"foreignKey:AuthorID"`
	Reactions    []Reaction `gorm:"foreignKey:AuthorID"`
	Messages      []Message      `gorm:"foreignKey:AuthorID"`
	Conversations []Conversation `gorm:"foreignKey:AuthorID"`
	Reels  []Reel  `gorm:"foreignKey:AuthorID"`
	Events []Event `gorm:"foreignKey:AuthorID"`
	Groups []Group  `gorm:"foreignKey:AuthorID"`
}


type User struct {
	AuthorID          uint                `grom:"primaryKey"`
	FirstName         string              `gorm:"unique;not null;size:50"`
	SecondName        string              `gorm:"unique;not null;size:50"`
	Email             string              `gorm:"unique;not null;size:100"`
	Password          string              `gorm:"not null"`
	PictureUrl        *string             `gorm:"size:255"`
	BackgroundUrl     *string             `gorm:"size:255"`
	Birthday          *time.Time          `gorm:"type=text"`
	IsVerified        bool                `gorm:"default:false"`
	Bio               string              `gorm:"default:'Edit bio';size:160"`
	ExternalUserLinks []ExternalUserLinks `gorm:"foreignKey:UserID"`
	Friends           []*User             `gorm:"many2many:users_friends"`
	FriendRequests    []*FriendRequest    `gorm:"foreignKey:ReceiverID"`
	UserPrivilege     UserPrivilege       `gorm:"foreignKey:UserID"`

	UserPrivilegeID uint

	Author Author `gorm:"foreignKey:AuthorID"`
}

type ExternalUserLinks struct {
	Model
	UserID   uint
	Platform string `gorm:"not null;size:60"`
	Link     string `gorm:"not null;size:60"`
}

type Page struct {
	Model
	AuthorID uint
	Author   Author `gorm:"foreignKey:AuthorID"`

	Title string `gorm:"not null;size:100"`
	Tags  []*Tag `gorm:"many2many:page_tags"`
	Views uint   `gorm:"default:0"`
	Likes uint   `gorm:"default:0"`
}

type Tag struct {
	Model
	PageID  uint
	TagName string  `gorm:"not null;unique;size:100"`
	Pages   []*Page `gorm:"many2many:page_tags"`
}

type FriendRequest struct {
	Model
	SenderID   uint `gorm:"not null"`
	ReceiverID uint `gorm:"not null"`
	StatusID   uint `gorm:"not null"`

	Sender   User                `gorm:"foreignKey:SenderID"`
	Receiver User                `gorm:"foreignKey:ReceiverID"`
	Status   FriendRequestStatus `gorm:"foreignKey:StatusID"`
}

type Comment struct {
	Model
	AuthorID uint
	Author   Author `gorm:"foreignKey:AuthorID"`

	Content string `gorm:"not null"`

	Hashtags []*Hashtag `gorm:"many2many:comment_hashtags"`
}

type Post struct {
	Model
	AuthorID uint `gorm:"not null"`
	Title    string
	Content  string `gorm:"not null"`
	IsPublic bool   `gorm:"default:true"`
	
	Location *Location `gorm:"foreignKey:LocationID;references:ID"`
	LocationID uint

	Hashtags []*Hashtag `gorm:"many2many:post_hashtags"`
}

type Location struct {
	Model
	City       string  `gorm:"size:100"`
	Country    string  `gorm:"size:100"`
	PostalCode string  `gorm:"size:20"`

	Geolocation *Geolocation `gorm:"foreignKey:GeolocationID;references:ID"`
	GeolocationID uint

	Address *Address `gorm:"foreignKey:AddressID;references:ID"`
	AddressID uint
	
}

type Geolocation struct{
	Model 
	Latitude   float64 `gorm:"not null"`
	Longitude  float64 `gorm:"not null"`
}

type Address struct{
	Model
	StreetName string  `gorm:"not null;size:255"`
	Building   string  `gorm:"size:20"`
	Gate	   string  `gorm:"size:20"`
	Floor      string  `gorm:"size:20"`
	Apartment  string  `gorm:"size:20"`
}

type Event struct {
	Model
	AuthorID    uint       `gorm:"not null"`
	Name        string     `gorm:"not null;size:300"`
	Description string     `gorm:"size:1024"`
	StartDate   *time.Time `gorm:"not null"`
	EndDate     *time.Time `gorm:"not null"`

	Members   []*Author `gorm:"many2many:event_members"`

	Location   *Location `gorm:"foreignKey:LocationID;references:ID"`
	LocationID uint
}

// zastanowic sie czy jest sens
type Reel struct {
	Model
	AuthorID uint   `gorm:"not null"`
	Content  string `gorm:"not null"`
}

 type Message struct {
 	Model
 	Content  string `gorm:"not null"`
	AuthorID uint `gorm:"not null"`
	ConversationID uint `gorm:"not null"`
// 	// Multimedia []*Multimedia
}

type Conversation struct {
 	Model
	Title string `gorm:"not null"`
	IconUrl string  
	AuthorID uint `gorm:"not null"`
	Members   []*Author `gorm:"many2many:conversation_members"`
	
}

type Advertisement struct {
	Model
	Content string `gorm:"not null"`
	AdLink  string `gorm:"not null"`
	PageID uint  `gorm:"not null"`
	// Media   []*Multimedia
}

type Group struct{
	Name string `gorm:"not null"`
	AuthorID uint `gorm:"not null"`
	Members   []*Author `gorm:"many2many:group_members"`	
}
