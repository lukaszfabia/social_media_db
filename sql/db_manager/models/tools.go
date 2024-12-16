package models

import (
	"github.com/brianvoe/gofakeit/v6"
	"gorm.io/gorm"
)

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
