package main

import (
	"net/http"

	"github.com/labstack/echo"
)

type get func() (*votingState, error)
type save func(*votingState) error

type votingOptions struct {
	Topics []string `json:"topics"`
}

type voteOption struct {
	Topic string `json:"topic"`
}

type votingState struct {
	Votes  map[string]int `json:"votes"`
	Winner string         `json:"winner"`
}

func getVotes(c echo.Context, getState get) error {
	state, err := getState()
	if err != nil {
		return err
	}
	return c.JSON(http.StatusOK, state)
}

func startVoting(c echo.Context, saveState save) error {
	topics := new(votingOptions)
	if err := c.Bind(topics); err != nil {
		return err
	}

	state := &votingState{make(map[string]int), ""}

	for _, val := range topics.Topics {
		state.Votes[val] = 0
	}

	return saveAndPublishState(c, state, saveState)
}

func vote(c echo.Context, getState get, saveState save) error {
	topic := new(voteOption)
	if err := c.Bind(&topic); err != nil {
		return err
	}

	state, err := getState()
	if err != nil {
		return err
	}

	if state.Winner != "" {
		return c.JSON(http.StatusBadRequest, state)
	}

	state.Votes[topic.Topic] = state.Votes[topic.Topic] + 1
	return saveAndPublishState(c, state, saveState)
}

func finishVoting(c echo.Context, getState get, saveState save) error {
	state, err := getState()
	if err != nil {
		return err
	}

	winner := getRandomKey(state.Votes)
	for topic, count := range state.Votes {
		if count > state.Votes[winner] {
			winner = topic
		}
	}

	state.Winner = winner
	return saveAndPublishState(c, state, saveState)
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
