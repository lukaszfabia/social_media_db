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

type EventName string

func (e *EventName) Faker(f *gofakeit.Faker) string {
	eventTypes := []string{
		"Conference", "Party", "Festival", "Summit", "Workshop", "Seminar", "Webinar",
	}

	eventType := f.RandomString(eventTypes)

	eventName := fmt.Sprintf("%s %s", eventType, gofakeit.Company())

	return eventName
}

type DateRange struct {
	StartDate time.Time
	EndDate   time.Time
}

func (d *DateRange) Faker(f *gofakeit.Faker) DateRange {
	sd := f.FutureDate()
	ed := sd.AddDate(0, 0, f.Number(0, 10))

	return DateRange{
		StartDate: sd,
		EndDate:   ed,
	}
}

type UniqueEmail string

func (u *UniqueEmail) Faker(f *gofakeit.Faker) string {
	return fmt.Sprintf("%s%d@%s.com", strings.ToLower(f.Username()), f.Number(1, 1000000), f.DomainName())

}
