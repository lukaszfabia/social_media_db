package seeder

import (
	"fmt"
	"log"
	"social_media/faker"
	"social_media/models"

	"github.com/brianvoe/gofakeit/v6"
	"gorm.io/gorm"
)

type Seeder struct {
	db *gorm.DB
	f  *gofakeit.Faker
}

/*
Constructor, init seed

returns:
  - new seeder
*/
func New(db *gorm.DB, f *gofakeit.Faker) *Seeder {
	return &Seeder{db: db, f: f}
}

// Simple wrapper for fill functions
func (s *Seeder) factory(f func() bool, count int) {
	var done int = 0

	for done < count {
		if f() {
			done++
		}
	}

	log.Println("Done!")
}

// Generates some tags, fills simple fields
func (s *Seeder) FillTags(count int) {
	s.factory(func() bool {
		var tag models.Tag = models.Tag{
			TagName: gofakeit.Noun(),
		}
		return s.db.Create(&tag).Error == nil
	}, count)
}

// TODO: finish it
func (s *Seeder) FillPages(count int) {
	var dummyTitle faker.Title

	s.factory(func() bool {
		likes := float64(gofakeit.Number(0, 1000000))
		views := likes*gofakeit.Float64Range(1.4, 5.4) + gofakeit.Float64Range(23, 212)

		var page models.Page = models.Page{
			Title: dummyTitle.Fake(s.f),
			Likes: uint(likes),
			Views: uint(views),
		}

		return s.db.Create(&page).Error == nil
	}, count)
}

// Generates fake locations (location, coords, address)
func (s *Seeder) FillLocations(count int) {
	s.factory(func() bool {
		dummyAddress := gofakeit.Address()
		var geolocation *models.Geolocation = &models.Geolocation{
			Latitude:  dummyAddress.Latitude,
			Longitude: dummyAddress.Longitude,
		}
		s.db.Create(&geolocation)

		// TODO: what do you mean about building, gate, floor, apartment
		var address *models.Address = &models.Address{
			StreetName: gofakeit.StreetName(),
			Building:   fmt.Sprintf("%d", gofakeit.Number(1, 100)),
			Gate:       fmt.Sprintf("%d", gofakeit.Number(1, 10)),
			Floor:      fmt.Sprintf("%d", gofakeit.Number(0, 20)),
			Apartment:  fmt.Sprintf("%d", gofakeit.Number(1, 100)),
		}
		s.db.Create(&address)

		var loc models.Location = models.Location{
			City:       gofakeit.City(),
			Country:    gofakeit.Country(),
			PostalCode: dummyAddress.Zip,

			Geolocation:   geolocation,
			GeolocationID: geolocation.ID,

			Address:   address,
			AddressID: address.ID,
		}

		return s.db.Create(&loc).Error == nil
	}, count)
}

// Generates random hashtags
func (s *Seeder) FillHashtags(count int) {
	s.factory(func() bool {
		var dummyHashtag faker.Hashtag

		return s.db.Create(&models.Hashtag{
			TagName: dummyHashtag.Fake(s.f),
		}).Error == nil
	}, count)
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

func (s *Seeder) FillPrivileges() {
	privileges := []string{"mod", "admin", "user"}
	nextPriv := nextPrivilege(privileges)

	s.factory(func() bool {
		priv := nextPriv()
		if priv == nil {
			return false
		}
		return s.db.Create(&models.UserPrivilege{
			PrivilegeName: *priv,
		}).Error == nil
	}, len(privileges))
}
