package main

import (
	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type votingStatDoc struct {
	ID     primitive.ObjectID `bson:"_id"`
	Votes  map[string]int     `bson:"votes"`
	Winner string             `bson:"winner"`
}

var (
	mongoClient, err = mongo.Connect(context.Background(), options.Client().ApplyURI(getEnv("MONGO", "mongodb://localhost:27017")))
	collection       = mongoClient.Database("votingapp").Collection("votes")
	votingStateID    = primitive.NewObjectID()
	votingID         = bson.M{"_id": votingStateID}
)

func getStateFromMongo() (*votingState, error) {
	state := new(votingState)
	err = collection.FindOne(context.Background(), votingID).Decode(state)
	if err != nil {
		return nil, err
	}

	return state, nil
}

func saveStateToMongo(state *votingState) error {
	_, err = collection.UpdateOne(context.Background(),
		votingID,
		bson.M{
			"$set": bson.M{
				"votes":  state.Votes,
				"winner": state.Winner,
			},
		},
		options.Update().SetUpsert(true))

	return err
}
