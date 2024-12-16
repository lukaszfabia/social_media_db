package models

// create here your enums...

type AuthorType string

const (
	PageType AuthorType = "page"
	UserType AuthorType = "user"
)

type FriendRequestStatus string

const (
	Pending  FriendRequestStatus = "pending"
	Rejected FriendRequestStatus = "rejected"
	Accepted FriendRequestStatus = "accepted"
)

type ReactionType string

const (
	Like  ReactionType = "like"
	Love  ReactionType = "love"
	Haha  ReactionType = "haha"
	Wow   ReactionType = "wow"
	Sad   ReactionType = "sad"
	Angry ReactionType = "angry"
)

var ReactionTypeLst = []string{
	string(Like),
	string(Love),
	string(Haha),
	string(Wow),
	string(Sad),
	string(Angry),
}
