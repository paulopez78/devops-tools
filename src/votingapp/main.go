package main

import (
	"net/http"

	"github.com/gorilla/websocket"
	"github.com/labstack/echo/v4"
)

var (
	upgrader = websocket.Upgrader{CheckOrigin: func(r *http.Request) bool { return true }}
	clients  []*websocket.Conn
	e        = echo.New()
)

func main() {
	//time.Sleep(5 * time.Second)
	e.Static("/", "ui")

	api := "/vote"
	if existsEnv("REDIS") {
		e.GET(api, composeGet(GetVotes, getStateFromRedis))
		e.POST(api, composeSave(Start, saveStateToRedis))
		e.PUT(api, composeGetAndSave(Vote, getStateFromRedis, saveStateToRedis))
		e.DELETE(api, composeGetAndSave(Finish, getStateFromRedis, saveStateToRedis))
	} else if existsEnv("MONGO") {
		e.GET(api, composeGet(GetVotes, getStateFromMongo))
		e.POST(api, composeSave(Start, saveStateToMongo))
		e.PUT(api, composeGetAndSave(Vote, getStateFromMongo, saveStateToMongo))
		e.DELETE(api, composeGetAndSave(Finish, getStateFromMongo, saveStateToMongo))
	} else {
		e.GET(api, composeGet(GetVotes, getStateFromMem))
		e.POST(api, composeSave(Start, saveStateToMem))
		e.PUT(api, composeGetAndSave(Vote, getStateFromMem, saveStateToMem))
		e.DELETE(api, composeGetAndSave(Finish, getStateFromMem, saveStateToMem))
	}

	e.GET("/ws", log(serveWs))
	e.GET("/ready", func(c echo.Context) error {
		// if rand.Intn(100) > 50 {
		// 	return c.String(http.StatusInternalServerError, "not ready")
		// }

		return c.String(http.StatusOK, "ready")
	})
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
