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
