package models

import (
	"log"

	"github.com/brianvoe/gofakeit/v6"
	"gorm.io/gorm"
)

/*
Get random author from db to assign it other row, handle if its null

returns:

  - ptr to Author
*/
func (a *Author) GetRandomAuthor(tx *gorm.DB, f *gofakeit.Faker) *Author {
	var randomAuthor *Author = nil
	var count int64

	// searching range of authors
	if err := tx.Model(&Author{}).Count(&count).Error; err == nil && count > 0 {
		// take random one
		if err := tx.First(&randomAuthor, "id = ?", f.Number(1, int(count))).Error; err != nil {
			log.Println(err)
			return nil
		}

		return randomAuthor
	}

	log.Println("No authors, please call it after FillAuthors")
	return nil
}

func (up *UserPrivilege) GetRandomPrivilege(tx *gorm.DB, f *gofakeit.Faker) *UserPrivilege {
	return nil
}
