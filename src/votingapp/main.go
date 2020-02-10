package main

import (
	"net/http"

	"github.com/gorilla/websocket"
	"github.com/labstack/echo"
)

var (
	upgrader = websocket.Upgrader{CheckOrigin: func(r *http.Request) bool { return true }}
	clients  []*websocket.Conn
	e        = echo.New()
)

func main() {
	// time.Sleep(5 * time.Second)
	e.Static("/", "ui")

	api := "/vote"

	if existsEnv("REDIS") {
		e.GET(api, composeGet(getVotes, getStateFromRedis))
		e.POST(api, composeSave(startVoting, saveStateToRedis))
		e.PUT(api, composeGetAndSave(vote, getStateFromRedis, saveStateToRedis))
		e.DELETE(api, composeGetAndSave(finishVoting, getStateFromRedis, saveStateToRedis))
	} else if existsEnv("MONGO") {
		e.GET(api, composeGet(getVotes, getStateFromMongo))
		e.POST(api, composeSave(startVoting, saveStateToMongo))
		e.PUT(api, composeGetAndSave(vote, getStateFromMongo, saveStateToMongo))
		e.DELETE(api, composeGetAndSave(finishVoting, getStateFromMongo, saveStateToMongo))
	} else {
		e.GET(api, composeGet(getVotes, getStateFromMem))
		e.POST(api, composeSave(startVoting, saveStateToMongo))
		e.PUT(api, composeGetAndSave(vote, getStateFromMem, saveStateToMem))
		e.DELETE(api, composeGetAndSave(finishVoting, getStateFromMem, saveStateToMem))
	}

	e.GET("/ws", log(serveWs))
	e.Logger.Fatal(e.Start(":5000"))
}

func sendMessage(value interface{}) error {
	var err error
	for _, client := range clients {
		err = client.WriteJSON(value)
	}
	return err
}

// serveWs handles websocket requests from the peer.
func serveWs(c echo.Context) error {
	conn, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
	if err != nil {
		return err
	}
	clients = append(clients, conn)
	return nil
}
