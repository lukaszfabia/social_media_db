package database

import (
	"fmt"
	"log"
	"math"
	"social_media/faker"
	"social_media/models"
	"social_media/pkg"
	"strings"

	"github.com/brianvoe/gofakeit/v6"
	"gorm.io/gorm"
)

type SeederService interface {
	FillTags(count int)
	FillPages(count int)
	FillLocations(count int)
	FillHashtags(count int)
	FillPrivileges()
	FillUsers(count int)

	FillAuthors(count int)
	FillComments(count int)
	FillReels(count int)
	FillFriendsAndFriendRequests(count int) // unstable
	FillPostAndReactions(count int)
	FillAuthorLists()
	FillGroups(count int)
	FillMessagesAndConversations(count int)
}

type seederServiceImpl struct {
	db *gorm.DB
	f  *gofakeit.Faker
}

// New instance of seeder service
func NewSeederService(db *gorm.DB, f *gofakeit.Faker) SeederService {
	return &seederServiceImpl{
		db: db,
		f:  f,
	}
}

// Getter which returns instance which has been created during connecting with database
func (s *service) SeederService() SeederService {
	return s.seederService
}

// Simple wrapper for fill functions
// If there was an error occured during creating row it will work until done achieve count
func (s *seederServiceImpl) factory(f func() bool, count int, info *string) {
	var done int = 0
	var failCount int = 0
	maxFailCount := int(math.Ceil(float64(count) / 2.0)) // if 50% of rows fail, just stop it // if 50% of row will be failed just stop it

	for done < count && maxFailCount > failCount {
		if f() {
			done++
		} else {
			failCount++
		}
	}

	if maxFailCount == failCount {
		log.Println("Can't make more sorry :(")
		return
	}

	if info != nil {
		log.Println(*info)
	}
}

// Generates some tags, fills simple fields
func (s *seederServiceImpl) FillTags(count int) {
	var info string = fmt.Sprintf("%d Tags have been added", count)

	s.factory(func() bool {
		var tag models.Tag = models.Tag{
			TagName: s.f.Noun(),
		}
		return s.db.Create(&tag).Error == nil
	}, count, &info)
}

// Generates entire page
func (s *seederServiceImpl) FillPages(count int) {
	var dummyTitle faker.Title
	var info string = fmt.Sprintf("%d Pages have been added", count)

	s.factory(func() bool {
		likes := float64(s.f.Number(0, 1000000))
		views := likes*s.f.Float64Range(1.4, 5.4) + s.f.Float64Range(23, 212)

		var tags []*models.Tag
		s.factory(func() bool {
			randtag := models.GetRandomModel(s.db, s.f, &models.Tag{})
			if tag, ok := randtag.(*models.Tag); ok {
				tags = append(tags, tag)
				return true
			}
			log.Println("Failed to retrieve a random tag or type assertion failed")
			return false
		}, s.f.Number(1, 10), nil)

		var page models.Page
		pageType := models.PageType

		randomAuthor, err := CreateRandomAuthor(s, &pageType)
		if err != nil {
			log.Println("Failed to create random author:", err)
			return false
		}

		if randomAuthor != nil {
			page.AuthorID = randomAuthor.ID
			page.Author = *randomAuthor
		}

		page.Title = dummyTitle.Fake(s.f)
		page.Tags = tags
		page.Likes = uint(likes)
		page.Views = uint(views)

		if err := s.db.Create(&page).Error; err != nil {
			log.Println("Failed to create page:", err)
			return false
		}

		var ads []*models.Advertisement
		adsAmount := s.f.Number(1, 5) * s.f.Number(1, 5)
		s.factory(func() bool {
			ad := &models.Advertisement{
				Content: s.f.Sentence(s.f.Number(10, 100)),
				AdLink:  s.f.URL(),
				PageID:  page.ID,
			}
			if err := s.db.Create(&ad).Error; err == nil {
				ads = append(ads, ad)
				return true
			}
			log.Println("Failed to create advertisement")
			return false
		}, adsAmount, nil)

		page.Advertisements = ads
		return s.db.Save(&page).Error == nil
	}, count, &info)
}

// Generates fake entire locations
func (s *seederServiceImpl) FillLocations(count int) {
	var info string = fmt.Sprintf("%d Locations have been added", count)

	s.factory(func() bool {
		dummyAddress := s.f.Address()
		var geolocation *models.Geolocation = &models.Geolocation{
			Latitude:  dummyAddress.Latitude,
			Longitude: dummyAddress.Longitude,
		}
		s.db.Create(&geolocation)

		var address *models.Address = &models.Address{
			StreetName: s.f.StreetName(),
			Building:   fmt.Sprintf("%d", s.f.Number(1, 100)),
			Gate:       fmt.Sprintf("%d", s.f.Number(1, 10)),
			Floor:      fmt.Sprintf("%d", s.f.Number(0, 20)),
			Apartment:  fmt.Sprintf("%d", s.f.Number(1, 100)),
		}
		s.db.Create(&address)

		var loc models.Location = models.Location{
			City:       s.f.City(),
			Country:    s.f.Country(),
			PostalCode: dummyAddress.Zip,

			Geolocation:   geolocation,
			GeolocationID: geolocation.ID,

			Address:   address,
			AddressID: address.ID,
		}

		return s.db.Create(&loc).Error == nil
	}, count, &info)
}

// Generates random hashtags
func (s *seederServiceImpl) FillHashtags(count int) {
	var info string = fmt.Sprintf("%d Hashtags have been added", count)

	s.factory(func() bool {
		var dummyHashtag faker.Hashtag
		hashtag := dummyHashtag.Fake(s.f)
		hashtag = strings.Replace(hashtag, " ", "", -1)

		return s.db.Create(&models.Hashtag{
			TagName: hashtag,
		}).Error == nil
	}, count, &info)
}

// Simple generator
func nextPrivilege(arr []string) func() *string {
	offset := 0

	return func() *string {
		if offset >= len(arr) {
			return nil
		}
		priv := arr[offset]
		offset++
		return &priv
	}
}

func (s *seederServiceImpl) FillPrivileges() {
	privileges := []string{"mod", "admin", "user"}
	nextPriv := nextPrivilege(privileges)

	s.factory(func() bool {
		priv := nextPriv()
		if priv == nil {
			return false
		}
		return s.db.Save(&models.UserPrivilege{
			PrivilegeName: *priv,
		}).Error == nil
	}, len(privileges), nil)
}

// Generates "count" users without friends and friends request
func (s *seederServiceImpl) FillUsers(count int) {
	var info string = fmt.Sprintf("%d Users have been added", count)

	s.factory(func() bool {
		var user models.User

		userType := models.UserType

		randomAuthor, err := CreateRandomAuthor(s, &userType)
		if err != nil {
			log.Println("Failed to create random author:", err)
			return false
		}

		var birthday faker.Birthday
		var up models.UserPrivilege

		if randomAuthor != nil {
			user.Author = *randomAuthor
			user.Author.ID = randomAuthor.ID
		} else {
			return false
		}

		var reallyUniqueEmail faker.UniqueEmail

		user.FirstName = s.f.FirstName()
		user.SecondName = s.f.LastName()
		user.Email = reallyUniqueEmail.Faker(s.f)

		if hashed, err := pkg.HashPassword(s.f.Password(true, true, true, true, false, 50)); err != nil {
			log.Println(err)
			return false
		} else {
			user.Password = hashed
		}

		user.Bio = s.f.HipsterSentence(20)

		user.Birthday = birthday.Fake(s.f)

		user.PictureUrl = &s.f.Person().Image

		background := s.f.ImageURL(1920, 1080)
		user.BackgroundUrl = &background

		user.IsVerified = s.f.Bool()

		if up, err := up.GetRandomPrivilege(s.db, s.f); err != nil {
			log.Println("Cant get random priv")
			return false
		} else {
			user.UserPrivilegeID = up.ID
		}

		var error = s.db.Create(&user).Error
		if error != nil {
			log.Println("Failed to create user:", error)
			return false
		}
		return true
	}, count, &info)
}

func (s *seederServiceImpl) FillAuthors(count int) {
	var info string = fmt.Sprintf("%d Authors have been added", count)

	s.factory(func() bool {
		_, err := CreateRandomAuthor(s, nil)
		if err != nil {
			log.Println("Failed to create random author:", err)
			return false
		}
		return err == nil
	}, count, &info)
}

func CreateRandomAuthor(s *seederServiceImpl, authorType *models.AuthorType) (*models.Author, error) {
	var author models.Author
	var at models.AuthorType

	if authorType == nil {
		var err error
		authorType, err = at.GetRandomAuthorType(s.db, s.f)
		if err != nil {
			return nil, err
		}
	}

	author.AuthorType = *authorType
	if err := s.db.Create(&author).Error; err != nil {
		return nil, err
	}
	return &author, nil
}

func (s *seederServiceImpl) FillComments(count int) {
	var info string = fmt.Sprintf("%d Comments have been added", count)

	s.factory(func() bool {
		var comment models.Comment
		var a models.Author

		if randomAuthor := a.GetRandomAuthor(s.db, s.f, nil); randomAuthor != nil {
			comment.AuthorID = randomAuthor.ID
			comment.Author = *randomAuthor
		}

		comment.Content = s.f.Sentence(10)

		if err := s.db.Create(&comment).Error; err != nil {
			log.Println("Failed to create comment")
			return false
		}

		//get some hashtags
		s.factory(func() bool {
			hashtag := models.GetRandomModel(s.db, s.f, &models.Hashtag{})
			if tag, ok := hashtag.(*models.Hashtag); ok {
				comment.Hashtags = append(comment.Hashtags, tag)
				return true
			} else {
				log.Println("Failed to add hashtag")
				return false
			}
		}, s.f.Number(1, 10), nil)

		// overwrite comment with hashtags
		if err := s.db.Save(&comment).Error; err != nil {
			log.Println("Failed to save comment")
			return false
		}

		return true
	}, count, &info)
}

func (s *seederServiceImpl) FillReels(count int) {
	var info string = fmt.Sprintf("%d Reels have been added", count)

	s.factory(func() bool {
		var reel models.Reel = models.Reel{
			Content: s.f.SentenceSimple(),
		}
		var a models.Author

		if randomAuthor := a.GetRandomAuthor(s.db, s.f, nil); randomAuthor != nil {
			reel.AuthorID = randomAuthor.ID
		}

		return s.db.Create(&reel).Error == nil
	}, count, &info)
}

func (s *seederServiceImpl) FillFriendsAndFriendRequests(count int) {
	var info string = fmt.Sprintf("%d friends and requests have been added", count)

	var users []models.User
	if err := s.db.Find(&users).Error; err != nil {
		log.Println("Failed to fetch users from db:", err)
		return
	}

	usersAmount := len(users)

	if usersAmount < 2 {
		log.Println("Not enough users to create friends")
		return
	}

	// new transaction
	tx := s.db.Begin()
	if tx.Error != nil {
		log.Println("Failed to start transaction:", tx.Error)
		return
	}

	s.factory(func() bool {
		sender := users[s.f.Number(0, usersAmount-1)]
		receiver := users[s.f.Number(0, usersAmount-1)]

		friendRequest := models.FriendRequest{
			SenderID:   sender.AuthorID,
			ReceiverID: receiver.AuthorID,
			Sender:     sender,
			Receiver:   receiver,
		}

		if err := tx.Create(&friendRequest).Error; err != nil {
			log.Println("Failed to save friend request:", err)
			tx.Rollback()
			return false
		}

		return true
	}, int((count / 2)), nil)

	s.factory(func() bool {
		user1 := users[s.f.Number(0, usersAmount-1)]
		user2 := users[s.f.Number(0, usersAmount-1)]

		if user1.AuthorID == user2.AuthorID {
			log.Println("Cant be in friendship with himself")
			return false
		}

		// check if a friend request exists
		var existingRequest models.FriendRequest
		if err := tx.Where("sender_id = ? AND receiver_id = ?", user1.AuthorID, user2.AuthorID).Or("sender_id = ? AND receiver_id = ?", user2.AuthorID, user1.AuthorID).First(&existingRequest).Error; err == nil {
			//log.Printf("Already exists this (%d, %d) of relation in friends requests\n", user1.AuthorID, user2.AuthorID)
			return false
		}

		// def friendship (user1, user2) <=> (user2, user1)
		if err := tx.Model(&user1).Association("Friends").Append(&user2); err != nil {
			log.Println("Failed to add friend:", err)
			tx.Rollback()
			return false
		}

		if err := tx.Model(&user2).Association("Friends").Append(&user1); err != nil {
			log.Println("Failed to add friend:", err)
			tx.Rollback()
			return false
		}

		if err := tx.Save(&user1).Error; err != nil {
			log.Println("Failed to save user1:", err)
			tx.Rollback()
			return false
		}

		if err := tx.Save(&user2).Error; err != nil {
			log.Println("Failed to save user2:", err)
			tx.Rollback()
			return false
		}

		return true
	}, int(len(users)/4), &info)

	if tx.Error == nil {
		if err := tx.Commit().Error; err != nil {
			log.Println("Failed to commit transaction:", err)
			tx.Rollback()
			return
		}
	} else {
		tx.Rollback()
	}
}

func (s *seederServiceImpl) FillPostAndReactions(count int) {
	// fetch all authors from the database
	authors := []*models.Author{}
	if err := s.db.Find(&authors).Error; err != nil {
		log.Println("Failed to fetch authors from db")
		return
	}

	var ptr int = 0

	s.factory(func() bool {
		author := authors[ptr]
		ptr++

		posts := s.createPostsForAuthor(author, count)

		author.Posts = append(author.Posts, posts...)

		if err := s.db.Save(&author).Error; err != nil {
			log.Println("Failed to save author")
			return false
		}

		return true
	}, len(authors), nil)
}

func (s *seederServiceImpl) createPostsForAuthor(author *models.Author, count int) []models.Post {
	var posts []models.Post

	s.factory(func() bool {
		post := models.Post{
			AuthorID: author.ID,
			Title:    s.f.Question(),
			Content:  s.f.HipsterSentence(50),
			IsPublic: s.f.Bool(),
		}

		randLocation := models.GetRandomModel(s.db, s.f, &models.Location{})
		if location, ok := randLocation.(*models.Location); ok {
			post.Location = location
			post.LocationID = location.ID
		}

		s.addHashtagsToPost(&post)

		if err := s.db.Save(&post).Error; err != nil {
			log.Println("Failed to save post")
			return false
		}

		s.createReactionsForPost(post, count, author)

		posts = append(posts, post)
		return true
	}, s.f.Number(1, count), nil)

	return posts
}

func (s *seederServiceImpl) addHashtagsToPost(post *models.Post) {
	randHashtagAmount := s.f.Number(1, 10)

	s.factory(func() bool {
		hashtag := models.GetRandomModel(s.db, s.f, &models.Hashtag{})
		if tag, ok := hashtag.(*models.Hashtag); ok {
			post.Hashtags = append(post.Hashtags, tag)
			return true
		}
		log.Println("Failed to add hashtag")
		return false
	}, randHashtagAmount, nil)
}

func (s *seederServiceImpl) createReactionsForPost(post models.Post, count int, author *models.Author) {
	authors := []*models.Author{}
	if err := s.db.Find(&authors).Error; err != nil {
		log.Println("Failed to fetch authors for reactions")
		return
	}

	s.factory(func() bool {
		// get rand author
		randAuthor := authors[s.f.Number(1, len(authors)-1)]
		if randAuthor != nil {
			reaction := models.Reaction{
				AuthorID: randAuthor.ID,
				PostID:   post.ID,
				Reaction: s.f.RandomString(models.ReactionTypeLst),
			}

			if err := s.db.Save(&reaction).Error; err != nil {
				log.Println("Failed to save reaction")
				return false
			}

			if author.ID == randAuthor.ID {
				author.Reactions = append(author.Reactions, reaction)
			}

			return true
		}
		return false
	}, s.f.Number(1, count), nil)
}

func (s *seederServiceImpl) FillGroups(count int) {
	s.factory(func() bool {
		var name faker.GroupName

		groupName := name.Faker(s.f)

		authorCount := s.f.Number(1, 6)

		var authors []*models.Author
		if err := s.db.Limit(authorCount).Find(&authors).Error; err != nil {
			log.Println("Error fetching authors:", err)
			return false
		}

		if len(authors) < 1 {
			log.Println("Not enough authors to create a group")
			return false
		}

		group := &models.Group{
			Name:    groupName,
			Members: authors,
		}

		if err := s.db.Create(group).Error; err != nil {
			log.Println("Error creating group:", err)
			return false
		}

		fmt.Printf("Group '%s' created with %d members.\n", groupName, len(authors))
		return true
	}, count, nil)
}

func (s *seederServiceImpl) FillMessagesAndConversations(count int) {
	s.factory(func() bool {
		iconUrl := s.f.ImageURL(200, 200)
		var title faker.Title
		var authors []*models.Author
		if err := s.db.Limit(s.f.Number(1, 20)).Find(&authors).Error; err != nil {
			log.Println("Error fetching authors:", err)
			return false
		}

		conversation := &models.Conversation{
			Title:    title.Fake(s.f),
			IconUrl:  iconUrl,
			AuthorID: authors[0].ID, // first fetched is admin of group
			Members:  authors,
		}

		if err := s.db.Create(conversation).Error; err != nil {
			log.Println("Error creating conversation:", err)
			return false
		}

		msgLen := s.f.Number(1, 10)

		for i := 0; i < msgLen; i++ {
			messageContent := s.f.SentenceSimple()
			message := &models.Message{
				Content:        messageContent,
				AuthorID:       authors[s.f.Number(1, len(authors)-1)].ID, // random author from the members
				ConversationID: conversation.ID,
			}

			if err := s.db.Create(message).Error; err != nil {
				log.Println("Error creating message:", err)
				return false
			}
		}

		return true
	}, count, nil)
}

func (s *seederServiceImpl) FillAuthorLists() {
	info := fmt.Sprintf("Authors have been filled")

	// get all authors from db
	var authors []*models.Author
	if err := s.db.Find(&authors).Error; err != nil {
		log.Println("No authors found. Please create authors before calling this function!")
		return
	}

	var ptr int = 0

	s.factory(func() bool {
		// process each author
		curr := authors[ptr]
		ptr++

		// create events and external links for the author
		curr.Events = s.createEventsForAuthor(curr.ID) // sets events where author is events admin
		curr.Comments = s.findAuthorsComments(curr.ID)
		curr.ExternalAuthorLinks = s.createExternalLinksForAuthor(curr.ID)
		curr.Reels = s.findAuthorsReels(curr.ID)
		curr.Groups = s.setGroups(curr.ID)
		curr.Conversations = s.getConversations(curr.ID) // converstation where author is admin
		curr.Messages = s.getMessages(curr.ID)

		return s.db.Save(&curr).Error == nil
	}, len(authors), &info)
}

func (s *seederServiceImpl) getConversations(authorID uint) []models.Conversation {
	var conversations []models.Conversation

	s.db.Find(&conversations, "author_id = ?", authorID)

	return conversations
}

func (s *seederServiceImpl) getMessages(authorID uint) []models.Message {
	var messages []models.Message

	s.db.Find(&messages, "author_id = ?", authorID)

	return messages
}

func (s *seederServiceImpl) setGroups(authorID uint) []models.Group {
	var groups []models.Group

	s.db.Preload("Members", "author_id = ?", authorID).Find(&groups)

	return groups
}

func (s *seederServiceImpl) findAuthorsComments(authorID uint) []models.Comment {
	var comments []models.Comment

	if err := s.db.Model(&models.Comment{}).Find(&comments, "author_id = ?", authorID).Error; err != nil {
		log.Println("Author has no comments")
		return nil
	}

	return comments
}

func (s *seederServiceImpl) findAuthorsReels(authorID uint) []models.Reel {
	var reels []models.Reel

	if err := s.db.Model(&models.Reel{}).Find(&reels, "author_id = ?", authorID).Error; err != nil {
		log.Println("Author has no comments")
		return nil
	}

	return reels
}

func (s *seederServiceImpl) createEventsForAuthor(authorID uint) []models.Event {
	var events []models.Event

	s.factory(func() bool {
		var e faker.EventName
		var rd faker.DateRange
		dates := rd.Faker(s.f)

		randLocation := models.GetRandomModel(s.db, s.f, &models.Location{})
		event := models.Event{
			AuthorID:    authorID,
			Name:        e.Faker(s.f),
			Description: s.f.Sentence(40),
			StartDate:   &(dates.StartDate),
			EndDate:     &dates.EndDate,
		}

		if location, ok := randLocation.(*models.Location); ok {
			event.Location = location
			event.LocationID = location.ID
		}

		if err := s.db.Save(&event).Error; err != nil {
			log.Println(err)
			return false
		}

		// take n ppl
		s.factory(func() bool {
			var chosen models.Author

			if err := s.db.Where("id <> ?", authorID).Order("RANDOM()").First(&chosen).Error; err != nil {
				log.Println("Failed to find random author")
				return false
			}

			event.Members = append(event.Members, &chosen)
			return true
		}, s.f.Number(1, 10), nil)

		events = append(events, event)
		return true
	}, s.f.Number(0, 40), nil)

	return events
}

func (s *seederServiceImpl) createExternalLinksForAuthor(authorID uint) []models.ExternalAuthorLink {
	var links []models.ExternalAuthorLink

	s.factory(func() bool {
		pl := faker.PlatformWithLink{}
		gen := pl.Fake(s.f)
		link := models.ExternalAuthorLink{
			AuthorID: authorID,
			Platform: gen.Platform,
			Link:     gen.Link,
		}

		if err := s.db.Create(&link).Error; err != nil {
			log.Println("Failed to create link for author")
			return false
		}

		links = append(links, link)
		return true
	}, s.f.Number(1, 4), nil)

	return links
}
