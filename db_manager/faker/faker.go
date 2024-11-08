package faker

import (
	"fmt"
	"strings"
	"time"

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

type Hashtag string

// Creates dummy hashtag
func (t *Hashtag) Fake(f *gofakeit.Faker) string {
	mySet := []string{
		f.HipsterWord(),
		f.HackeringVerb(),
		f.HackerNoun(),
		f.NounAbstract(),
		f.CarModel(),
		f.CarType(),
		f.Language(),
		f.MinecraftFood(),
	}

	return f.RandomString(mySet)
}

type Birthday time.Time

// Adult people only
func (t *Birthday) Fake(f *gofakeit.Faker) *time.Time {
	d := f.DateRange(time.Now().AddDate(-100, 0, 0), time.Now().AddDate(-18, 0, 0))
	return &d
}

type PlatformWithLink struct {
	Platform string
	Link     string
}

// Popular social media generator
func (p *PlatformWithLink) Fake(f *gofakeit.Faker) PlatformWithLink {
	socialMediaPlatforms := []string{"Twitter", "Instagram", "Facebook", "LinkedIn", "TikTok", "Snapchat", "YouTube", "Pinterest", "Reddit"}

	var pl PlatformWithLink

	pl.Platform = f.RandomString(socialMediaPlatforms)

	uuid := f.UUID()

	pl.Link = fmt.Sprintf("https://%s.com/%s", strings.ToLower(pl.Platform), uuid)

	return pl
}
