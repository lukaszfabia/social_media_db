package faker

import (
	"fmt"

	"github.com/brianvoe/gofakeit/v6"
)

type Title string

// Creates dummy title for page
func (t *Title) Fake(f *gofakeit.Faker) string {
	mySet := []string{
		f.HipsterWord(),
		f.School(),
		f.AppName(),
		fmt.Sprintf("%s - %s page", f.Company(), f.NounAbstract()),
	}

	return f.RandomString(mySet)
}