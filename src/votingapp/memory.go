package main

var (
	state *votingState = &votingState{}
)

func getStateFromMem() (*votingState, error) {
	return state, nil
}

func saveStateToMem(votingState *votingState) error {
	state = votingState
	return nil
}
