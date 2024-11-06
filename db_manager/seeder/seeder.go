package seeder

import (
	"log"
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

func (s *Seeder) FillPages(count int) {

}
