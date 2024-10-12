package database

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
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
		Host:     "localhost",
		User:     os.Getenv("POSTGRES_USER"),
		Password: os.Getenv("POSTGRES_PASSWORD"),
		DBName:   os.Getenv("POSTGRES_DB"),
		Port:     "5432",
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", c.Host, c.User, c.Password, c.DBName, c.Port)
	Db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("Can't connect to db!")
	} else {
		log.Println("Successfully connected to db!")
	}
}
