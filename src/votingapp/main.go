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
		e.GET(api, log(func(c echo.Context) error { return getVotes(c, getStateFromRedis) }))
		e.POST(api, log(func(c echo.Context) error { return startVoting(c, saveStateToRedis) }))
		e.PUT(api, log(func(c echo.Context) error { return vote(c, getStateFromRedis, saveStateToRedis) }))
		e.DELETE(api, log(func(c echo.Context) error { return finishVoting(c, getStateFromRedis, saveStateToRedis) }))
	} else {
		e.GET(api, log(func(c echo.Context) error { return getVotes(c, getStateFromMem) }))
		e.POST(api, log(func(c echo.Context) error { return startVoting(c, saveStateToMem) }))
		e.PUT(api, log(func(c echo.Context) error { return vote(c, getStateFromMem, saveStateToMem) }))
		e.DELETE(api, log(func(c echo.Context) error { return finishVoting(c, getStateFromMem, saveStateToMem) }))
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
