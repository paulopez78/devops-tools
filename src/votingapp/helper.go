package main

import (
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
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

func composeGet(handler func(echo.Context, get) error, getState get) echo.HandlerFunc {
	return log(func(c echo.Context) error {
		return handler(c, getState)
	})
}

func composeSave(handler func(echo.Context, save) error, saveState save) echo.HandlerFunc {
	return log(func(c echo.Context) error {
		return handler(c, saveState)
	})
}

func composeGetAndSave(handler func(echo.Context, get, save) error, getState get, saveState save) echo.HandlerFunc {
	return log(func(c echo.Context) error {
		return handler(c, getState, saveState)
	})
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

func saveAndPublishState(c echo.Context, state *votingState, saveState save) error {
	err := saveState(state)
	if err != nil {
		return err
	}

	err = sendMessage(state)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, state)
}
