package database

import (
	"log"
	"math"
	"social_media/models"
	"social_media/pkg"
)

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

func CreateRandomAuthor(s *seederServiceImpl, authorType *models.AuthorType) (*models.Author, error) {
	var author models.Author
	var at models.AuthorType

	if authorType == nil {
		var err error
		authorType, err = at.GetRandomAuthorType(s.db, s.f)
		if err != nil {
			pkg.LogError("get", "radom author type", err)
			return nil, err
		}
	}

	author.AuthorType = *authorType
	if err := s.db.Create(&author).Error; err != nil {
		pkg.LogError("create", "author", err)
		return nil, err
	}
	return &author, nil
}
