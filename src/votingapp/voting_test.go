package main

import "testing"

func TestShouldReturnExpectedWinnerWhenProperVotingSession(t *testing.T) {
	expectedWinner := "DevOps"
	topics := &votingOptions{[]string{"DevOps", "Dev", "Ops"}}

	state := start(topics)
	vote(state, &voteOption{"DevOps"})
	vote(state, &voteOption{"Dev"})
	vote(state, &voteOption{"Ops"})
	vote(state, &voteOption{"DevOps"})
	finish(state)

	if expectedWinner != state.Winner {
		t.Errorf("Expected winner is %s; but got %s", expectedWinner, state.Winner)
	}
}
