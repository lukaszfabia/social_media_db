package database

import (
	"fmt"
	"log"
	"social_media/faker"
	"social_media/models"
	"social_media/pkg"

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

	// TODO: implement
	FillAuthors(count int)
	FillComments(count int)
	FillReels(count int)
	FillFriendsAndFriendRequests(count int)
	FillEvent(count int)
	FillPostAndReactions(count int)
	FillGroups(count int)
	FillMessagesAndConversations(count int)
	FillGeolocations(count int)
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

	for done < count {
		if f() {
			done++
		}
	}

	if info != nil {
		log.Println(*info)
	} else {
		log.Println("Done!")
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

		var tags []*models.Tag = nil

		if err := s.db.Find(&tags).Error; err != nil {
			log.Println(err)
		}

		var ads []*models.Advertisement = nil
		adsAmount := s.f.Number(1, 5) * s.f.Number(1, 5)

		s.factory(func() bool {
			var ad *models.Advertisement = &models.Advertisement{
				Content: s.f.Sentence(s.f.Number(10, 100)),
				AdLink:  s.f.URL(),
			}
			if s.db.Create(&ad).Error == nil {
				ads = append(ads, ad)

				return true
			}
			return false
		}, adsAmount, nil) // generates random ads amount

		var a models.Author
		var page models.Page

		if randomAuthor := a.GetRandomAuthor(s.db, s.f); randomAuthor != nil {
			page.AuthorID = randomAuthor.ID
			page.Author = *randomAuthor
		}

		page.Title = dummyTitle.Fake(s.f)
		page.Tags = tags
		page.Advertisements = ads
		page.Likes = uint(likes)
		page.Views = uint(views)

		var error = s.db.Create(&page).Error
		println(error)

		return error == nil
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

		return s.db.Create(&models.Hashtag{
			TagName: dummyHashtag.Fake(s.f),
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

// this should crash if fails even once
func (s *seederServiceImpl) FillPrivileges() {
	privileges := []string{"mod", "admin", "user"}
	nextPriv := nextPrivilege(privileges)

	for i := 0; i < len(privileges); i++ {
		priv := nextPriv()
		if priv == nil {
			panic("Privilege is nil")
		}
		if err := s.db.Create(&models.UserPrivilege{
			PrivilegeName: *priv,
			Users:         nil,
		}).Error; err != nil {
			panic(fmt.Sprintf("Failed to create privilege: %s", err))
		}
	}

	log.Println("All privileges have been added")
}

// Generates "count" users without friends and friends request
func (s *seederServiceImpl) FillUsers(count int) {
	var info string = fmt.Sprintf("%d Users have been added", count)

	s.factory(func() bool {
		var user models.User
		var a models.Author
		var randomAuthor *models.Author = a.GetRandomAuthor(s.db, s.f)
		var birthday faker.Birthday
		var up models.UserPrivilege

		if randomAuthor != nil {
			user.Author = *randomAuthor
			user.Author.ID = randomAuthor.ID
		}

		user.FirstName = s.f.FirstName()
		user.SecondName = s.f.LastName()
		user.Email = s.f.Email()

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
			return false
		} else {
			user.UserPrivilegeID = up.ID
		}

		var links []models.ExternalUserLinks

		s.factory(func() bool {
			var p faker.PlatformWithLink
			link := models.ExternalUserLinks{
				AuthorID: randomAuthor.ID,
				Platform: p.Platform,
				Link:     p.Link,
			}

			if err := s.db.Create(&link).Error; err != nil {
				return false
			}

			links = append(links, link)

			return true
		}, s.f.Number(1, 4), nil)

		user.ExternalUserLinks = links

		return s.db.Create(&user).Error == nil
	}, count, &info)
}

// TODO: implement, (association tables you fill by adding list as a property where is demanded)
func (s *seederServiceImpl) FillAuthors(count int) {
	var info string = fmt.Sprintf("%d Authors have been added", count)

	s.factory(func() bool {
		var author models.Author

		var at models.AuthorType

		if up, err := at.GetRandomAuthorType(s.db, s.f); err != nil {
			return false
		} else {
			author.AuthorType = *up
		}

		author.Comments = nil
		author.Posts = nil
		author.Reactions = nil
		author.Messages = nil
		author.Conversations = nil
		author.Reels = nil
		author.Events = nil
		author.Groups = nil

		return s.db.Create(&author).Error == nil
	}, count, &info)
}

func (s *seederServiceImpl) FillComments(count int) {
	var info string = fmt.Sprintf("%d Comments have been added", count)

	s.factory(func() bool {
		var comment models.Comment
		var a models.Author

		if randomAuthor := a.GetRandomAuthor(s.db, s.f); randomAuthor != nil {
			comment.AuthorID = randomAuthor.ID
			comment.Author = *randomAuthor
		}

		comment.Content = s.f.Sentence(10)

		return s.db.Create(&comment).Error == nil
	}, count, &info)
}

func (s *seederServiceImpl) FillReels(count int) {
	var info string = fmt.Sprintf("%d Reels have been added", count)

	s.factory(func() bool {
		var reel models.Reel
		var a models.Author

		if randomAuthor := a.GetRandomAuthor(s.db, s.f); randomAuthor != nil {
			reel.AuthorID = randomAuthor.ID
		}

		return s.db.Create(&reel).Error == nil
	}, count, &info)
}

func (s *seederServiceImpl) FillFriendsAndFriendRequests(count int) {}
func (s *seederServiceImpl) FillEvent(count int) {
	var info string = fmt.Sprintf("%d Events have been added", count)

	s.factory(func() bool {
		var a models.Author
		randomAuthor := a.GetRandomAuthor(s.db, s.f)

		startDate := s.f.Date()

		var chance int = s.f.Number(0, 1000)

		var deltaDays int = 0
		if chance < 500 {
			deltaDays = s.f.Number(1, 14)
		}
		endDate := startDate.AddDate(0, 0, deltaDays)

		event := models.Event{
			AuthorID:    randomAuthor.ID,
			Name:        s.f.Sentence(3),
			Description: s.f.Paragraph(1, 3, 5, " "),
			StartDate:   &startDate,
			EndDate:     &endDate,
		}

		if err := s.db.Create(&event).Error; err != nil {
			log.Println(err)
			return false
		}

		return true
	}, count, &info)
}
func (s *seederServiceImpl) FillPostAndReactions(count int)         {}
func (s *seederServiceImpl) FillGroups(count int)                   {}
func (s *seederServiceImpl) FillMessagesAndConversations(count int) {}
func (s *seederServiceImpl) FillGeolocations(count int)             {}
