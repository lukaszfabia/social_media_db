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

func (up *UserPrivilege) GetRandomPrivilege(tx *gorm.DB, f *gofakeit.Faker) (*UserPrivilege, error) {

	// takePrivilege := func(name string) (*UserPrivilege, error) {
	// 	var res *UserPrivilege

	// 	if err := tx.First(&res, "privilege_name = ?", name).Error; err != nil {
	// 		return nil, err
	// 	}
	// 	return res, nil
	// }

	// max := 100000
	// var adminChance float32 = 0.01 * max
	// modChange := 0.1
	// chance := float64(gofakeit.Number(1, 100000))

	// if calcChange := max * adminChance; calcChange < max {
	// 	return takePrivilege("admin")
	// } else if chance >= 99997 && chance <= 99999 {
	// 	return takePrivilege("mod")
	// } else {
	// 	return takePrivilege("user")
	// }
	return nil, nil
}
