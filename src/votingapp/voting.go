package main

import (
	"net/http"

	"github.com/labstack/echo"
)

type votingOptions struct {
	Topics []string `json:"topics"`
}

type voteOption struct {
	Topic string `json:"topic"`
}

func getVotes(c echo.Context) error {
	state, err := getState()
	if err != nil {
		return err
	}
	return c.JSON(http.StatusOK, state)
}

func startVoting(c echo.Context) error {
	topics := new(votingOptions)
	if err := c.Bind(topics); err != nil {
		return err
	}

	state := votingState{make(map[string]int), ""}
	for _, val := range topics.Topics {
		state.Votes[val] = 0
	}

	return saveAndPublishState(c, &state)
}

func vote(c echo.Context) error {
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
	return saveAndPublishState(c, state)
}

func finishVoting(c echo.Context) error {
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
	return saveAndPublishState(c, state)
}

func saveAndPublishState(c echo.Context, state *votingState) error {
	err := saveState(*state)
	if err != nil {
		return err
	}

	err = sendMessage(state)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, state)
}
