package database

import (
	"errors"
	"fmt"
	"log"
	"os"
	"social_media/models"
	"strings"
	"time"

	"github.com/brianvoe/gofakeit/v6"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

type Credintials struct {
	Host     string
	User     string
	Password string
	DBName   string
	Port     string
}

type Service interface {
	Sync() error
	CreateEnum(enumName string, values ...string) error
	DropTables() error
	ClearAllTables()
	InitEnums()

	SeederService() SeederService

	Cook() // run filling
}

type service struct {
	db *gorm.DB

	seederService SeederService
}

// New connection with database, create service
func Connect(logFile *os.File) Service {

	customLogger := logger.New(
		log.New(logFile, "\n", log.LstdFlags),
		logger.Config{
			SlowThreshold: time.Second,
			LogLevel:      logger.Info,
			Colorful:      false,
		},
	)

	var c Credintials = Credintials{
		Host:     strings.TrimSpace(os.Getenv("HOST")),
		User:     strings.TrimSpace(os.Getenv("POSTGRES_USER")),
		Password: strings.TrimSpace(os.Getenv("POSTGRES_PASSWORD")),
		DBName:   strings.TrimSpace(os.Getenv("POSTGRES_DB")),
		Port:     strings.TrimSpace(os.Getenv("PORT")),
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", c.Host, c.User, c.Password, c.DBName, c.Port)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: customLogger,
	})
	if err != nil {
		panic("Can't connect to db!\n" + err.Error())
	} else {
		log.Println("Successfully connected to db!")
		var f *gofakeit.Faker = gofakeit.New(gofakeit.Date().UnixMilli())
		seederService := NewSeederService(db, f)

		return &service{
			db:            db,
			seederService: seederService,
		}
	}
}

/*
Create enum in db, uses raw SQL, please if you use it in models, you need to call it before Sync function

	params:
	- name of the enum
	- values
*/
func (s *service) CreateEnum(enumName string, values ...string) error {
	if len(values) == 0 {
		return errors.New("no values provided for enum")
	}

	var placeholders []string
	for range values {
		placeholders = append(placeholders, "'%s'")
	}
	strValues := strings.Join(placeholders, ",")

	var anyValues []any
	for _, v := range values {
		anyValues = append(anyValues, v)
	}

	query := fmt.Sprintf("CREATE TYPE \"%s\" AS ENUM (%s);", enumName, strValues)

	if err := s.db.Exec(fmt.Sprintf(query, anyValues...)).Error; err != nil {
		return nil
	}

	return nil
}

func (s *service) DropTables() error {
	for _, model := range AllModels {
		if err := s.db.Unscoped().Migrator().DropTable(model); err != nil {
			log.Fatalf("Failed to drop %T", model)
			return err
		}
	}

	nnTables := []string{
		"comment_hashtags", "conversation_members", "event_members", "group_members", "page_tags", "post_hashtags", "user_friends",
	}

	for _, table := range nnTables {
		query := fmt.Sprintf("DROP TABLE IF EXISTS %s", table)
		if err := s.db.Exec(query).Error; err != nil {
			log.Println("Error dropping table:", table, err)
			return err
		}
	}

	return nil
}

// Clear all data from db
func (s *service) ClearAllTables() {
	for _, model := range AllModels {
		if err := s.db.Unscoped().Session(&gorm.Session{AllowGlobalUpdate: true}).Delete(model).Error; err != nil {
			log.Println(err)
		}

	}
}

func (s *service) InitEnums() {
	if err := s.CreateEnum("author_type_enum", string(models.PageType), string(models.UserType)); err != nil {
		log.Println(err)
	}

	if err := s.CreateEnum("friend_request_status", string(models.Pending), string(models.Accepted), string(models.Rejected)); err != nil {
		log.Println(err)
	}

	if err := s.CreateEnum("reaction_type", string(models.Angry), string(models.Haha), string(models.Like), string(models.Love), string(models.Sad), string(models.Wow)); err != nil {
		log.Println(err)
	}
}

// Here you can stack fill funcs
func (s *service) Cook() {

	// s.seederService.FillPrivileges()
	// s.seederService.FillUsers(2700)
	// s.seederService.FillFriendsAndFriendRequests(100)
	// s.seederService.FillTags(234)
	// s.seederService.FillPages(100)
	// s.seederService.FillLocations(12451)
	// s.seederService.FillHashtags(345)
	// s.seederService.FillComments(54350)
	// s.seederService.FillReels(9000)
	// s.seederService.FillPostAndReactions(10)         // quite slow
	// s.seederService.FillMessagesAndConversations(10) // quite slow
	// s.seederService.FillGroups(20)
	// s.seederService.FillAuthorLists()

	// for test purposes

	s.seederService.FillPrivileges()
	s.seederService.FillUsers(10)
	// s.seederService.FillFriendsAndFriendRequests(100)
	s.seederService.FillTags(2)
	s.seederService.FillPages(1)
	s.seederService.FillLocations(2)
	s.seederService.FillHashtags(3)
	s.seederService.FillComments(2)
	s.seederService.FillReels(3)
	s.seederService.FillPostAndReactions(1)         // quite slow
	s.seederService.FillMessagesAndConversations(4) // quite slow
	s.seederService.FillGroups(2)
	s.seederService.FillAuthorLists()
}
