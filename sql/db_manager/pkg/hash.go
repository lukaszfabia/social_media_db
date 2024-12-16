package pkg

import (
	"errors"

	"golang.org/x/crypto/bcrypt"
)

func HashPassword(password string) (string, error) {

	if password == "" {
		return "", errors.New("password is empty")
	}

	hashed, err := bcrypt.GenerateFromPassword([]byte(password), 10)

	if err != nil {
		return "", errors.New("couldnt hash password")
	}

	return string(hashed), nil
}
