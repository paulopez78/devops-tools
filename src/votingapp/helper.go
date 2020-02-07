package main

import (
	"os"

	"github.com/labstack/echo"
)

func getEnv(key, fallback string) string {
	value := os.Getenv(key)
	if len(value) == 0 {
		return fallback
	}
	return value
}

func existsEnv(key string) bool {
	_, exists := os.LookupEnv(key)
	return exists
}

func getRandomKey(a map[string]int) string {
	for key := range a {
		return key
	}
	return ""
}

func log(h func(echo.Context) error) func(echo.Context) error {
	return func(c echo.Context) error {
		err := h(c)
		if err != nil {
			e.Logger.Error(err)
		}
		return err
	}
}
