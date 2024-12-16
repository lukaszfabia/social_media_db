package pkg

import "log"

func LogError(verb, table string, err error) {
	log.Printf("Failed to %s %s: %v", verb, table, err)
}
