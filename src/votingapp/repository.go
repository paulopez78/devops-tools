package main

import (
	"encoding/json"

	"github.com/go-redis/redis"
)

var (
	client = redis.NewClient(&redis.Options{Addr: getenv("REDIS", "localhost:6379")})
)

type votingState struct {
	Votes  map[string]int `json:"votes"`
	Winner string         `json:"winner"`
}

func getState() (*votingState, error) {
	val, err := client.Get("votingState").Result()
	if err != nil {
		return nil, err
	}
	b := []byte(val)
	state := &votingState{}
	err = json.Unmarshal(b, state)
	if err != nil {
		return nil, err
	}

	return state, nil
}

func saveState(state votingState) error {
	b, err := json.Marshal(&state)
	if err != nil {
		return err
	}

	return client.Set("votingState", string(b), 0).Err()
}
