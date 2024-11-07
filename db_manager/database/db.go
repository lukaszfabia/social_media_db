package database

import (
	"fmt"
	"log"
	"os"
	"strings"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var Db *gorm.DB

type Credintials struct {
	Host     string
	User     string
	Password string
	DBName   string
	Port     string
}

func Connect() {
	var err error

	var c Credintials = Credintials{
		Host:     strings.TrimSpace(os.Getenv("HOST")),
		User:     strings.TrimSpace(os.Getenv("POSTGRES_USER")),
		Password: strings.TrimSpace(os.Getenv("POSTGRES_PASSWORD")),
		DBName:   strings.TrimSpace(os.Getenv("POSTGRES_DB")),
		Port:     strings.TrimSpace(os.Getenv("PORT")),
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", c.Host, c.User, c.Password, c.DBName, c.Port)
	Db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	if err != nil {
		panic("Can't connect to db!")
	} else {
		log.Println("Successfully connected to db!")
	}
}
