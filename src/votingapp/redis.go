package main

import (
	"encoding/json"

	"github.com/go-redis/redis/v7"
)

var (
	client = redis.NewClient(&redis.Options{Addr: getEnv("REDIS", "localhost:6379")})
)

func getStateFromRedis() (*votingState, error) {
	val, err := client.Get("votingState").Result()
	if err != nil {
		return nil, err
	}
	b := []byte(val)
	state := new(votingState)
	err = json.Unmarshal(b, state)
	if err != nil {
		return nil, err
	}

	return state, nil
}

func saveStateToRedis(state *votingState) error {
	b, err := json.Marshal(state)
	if err != nil {
		return err
	}

	return client.Set("votingState", string(b), 0).Err()
}
