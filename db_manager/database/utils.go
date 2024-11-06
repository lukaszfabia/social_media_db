package database

import (
	"errors"
	"fmt"
	"log"
	"strings"
)

/*
Create enum in db, uses raw SQL, please if you use it in models, you need to call it before Sync function

	params:
	- name of the enum
	- values
*/
func CreateEnum(enumName string, values ...string) error {
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

	if err := Db.Exec(fmt.Sprintf(query, anyValues...)).Error; err != nil {
		return errors.New("Can't create new type, maybe already exists")
	}

	log.Printf("Created enum %s.\n", enumName)
	return nil
}

func DropTables() error {
	for _, model := range AllModels {
		if err := Db.Migrator().DropTable(model); err != nil {
			log.Fatalf("Failed to migarte %T", model)
			return err
		}
	}

	return nil
}

func ClearTable(table string) {
	q := fmt.Sprintf("TRUNCATE TABLE %s RESTART IDENTITY CASCADE", table)

	if err := Db.Exec(q).Error; err != nil {
		log.Fatalln(err)
	} else {
		log.Printf("%s has been cleared", table)
	}

}
