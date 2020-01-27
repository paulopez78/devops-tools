package main

import (
	"net/http"
	"time"

	"github.com/gorilla/websocket"
	"github.com/labstack/echo"
)

var (
	upgrader = websocket.Upgrader{CheckOrigin: func(r *http.Request) bool { return true }}
	clients  []*websocket.Conn
	e        = echo.New()
)

func main() {
	time.Sleep(5 * time.Second)
	e.Static("/", "ui")

	api := "/vote"
	e.GET(api, log(getVotes))
	e.POST(api, log(startVoting))
	e.PUT(api, log(vote))
	e.DELETE(api, log(finishVoting))
	e.GET("/ws", log(serveWs))

	e.Logger.Fatal(e.Start(":80"))
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
