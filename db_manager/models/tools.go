package models

import (
	"log"
	"reflect"

	"github.com/brianvoe/gofakeit/v6"
	"gorm.io/gorm"
)

func GetRandomModel(tx *gorm.DB, f *gofakeit.Faker, model any) any {
	var count int64

	if model == nil || reflect.ValueOf(model).Kind() != reflect.Ptr {
		log.Println("Error: model must be a non-nil pointer to a struct")
		return nil
	}

	if err := tx.Model(model).Count(&count).Error; err != nil {
		log.Println("Error counting records:", err)
		return nil
	}

	if count == 0 {
		log.Println("No records found in the table")
		return nil
	}

	offset := f.Number(0, int(count-1))
	if err := tx.Offset(offset).Limit(1).Find(model).Error; err != nil {
		log.Println("Error retrieving random record:", err)
		return nil
	}

	return model
}

/*
Get random author from db to assign it other row, handle if its null

returns:

  - ptr to Author
*/
func (a *Author) GetRandomAuthor(tx *gorm.DB, f *gofakeit.Faker, preferdAuthorType *AuthorType) *Author {
	var randomAuthor Author
	var count int64

	tmp := tx.Model(&Author{})

	if preferdAuthorType != nil {
		tmp.Where("author_type = ?", string(*preferdAuthorType))
	}

	if err := tmp.Count(&count).Error; err == nil && count > 0 {
		offset := f.Number(0, int(count-1))

		if err := tx.Offset(offset).Limit(1).Find(&randomAuthor).Error; err != nil {
			log.Println("Can't find random author")
			return nil
		}

		return &randomAuthor
	}

	log.Println("No authors, please call it after FillAuthors")
	return nil
}

func (at *AuthorType) GetRandomAuthorType(tx *gorm.DB, f *gofakeit.Faker) (*AuthorType, error) {
	var max float64 = 1000.0
	var userChance float64 = 0.9 * max

	chance := gofakeit.Number(1, int(max))

	if userThreshold := int(userChance); chance < userThreshold {
		userType := AuthorType("user")
		return &userType, nil
	} else {
		userType := AuthorType("page")
		return &userType, nil
	}
}

func (up *UserPrivilege) GetRandomPrivilege(tx *gorm.DB, f *gofakeit.Faker) (*UserPrivilege, error) {

	takePrivilege := func(name string) (*UserPrivilege, error) {
		var res *UserPrivilege

		if err := tx.First(&res, "privilege_name = ?", name).Error; err != nil {
			return nil, err
		}
		return res, nil
	}

	var max float64 = 1000.0
	var adminChance float64 = 0.003 * max
	var modChance float64 = 0.01 * max

	chance := gofakeit.Number(1, int(max))

	if adminThreshold := int(adminChance); chance < adminThreshold {
		return takePrivilege("admin")
	} else if modThreshold := int(modChance); chance < modThreshold {
		return takePrivilege("mod")
	} else {
		return takePrivilege("user")
	}

}
