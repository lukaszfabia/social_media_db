package database

import (
	"errors"
	"fmt"
	"log"
	"os"
	"social_media/models"
	"strings"

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
func Connect() Service {
	var c Credintials = Credintials{
		Host:     strings.TrimSpace(os.Getenv("HOST")),
		User:     strings.TrimSpace(os.Getenv("POSTGRES_USER")),
		Password: strings.TrimSpace(os.Getenv("POSTGRES_PASSWORD")),
		DBName:   strings.TrimSpace(os.Getenv("POSTGRES_DB")),
		Port:     strings.TrimSpace(os.Getenv("PORT")),
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", c.Host, c.User, c.Password, c.DBName, c.Port)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
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
		return errors.New("Can't create new type, maybe already exists")
	}

	log.Printf("Created enum %s.\n", enumName)
	return nil
}

func (s *service) DropTables() error {
	for _, model := range AllModels {
		if err := s.db.Migrator().DropTable(model); err != nil {
			log.Fatalf("Failed to migarte %T", model)
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

	// TODO: implement all

	s.seederService.FillTags(10)
	s.seederService.FillLocations(10)
	s.seederService.FillHashtags(10)
	s.seederService.FillPrivileges()
	s.seederService.FillAuthors(1000)
	s.seederService.FillComments(50)
	s.seederService.FillReels(50)
	s.seederService.FillEvent(50)
	//s.seederService.FillPages(10)
	//s.seederService.FillUsers(10)
}
