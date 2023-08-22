package main

import (
	"fmt"
	"math/rand"
	"os"
	"time"

	"github.com/cenkalti/rain/torrent"
)

func main() {
	println("Hello, World!")

	config := torrent.DefaultConfig
	config.Host = "137.66.12.135"

	// Random database name every time
	rand.Seed(time.Now().UnixNano())
	config.Database = fmt.Sprintf("/tmp/database/%d", rand.Int())

	config.PortBegin = 51413
	config.PortEnd = 51414
	config.PEXEnabled = false
	config.RPCEnabled = false
	config.DHTEnabled = false

	println(config.Database)

	session, err := torrent.NewSession(config)
	if err != nil {
		panic(err)
	}

	file, err := os.Open("/etc/torrent_files/congratulations.gif.torrent")
	if err != nil {
		panic(err)
	}

	torrent, err := session.AddTorrent(file, &torrent.AddTorrentOptions{ID: "congratulations.gif"})
	if err != nil {
		panic(err)
	}

	for {
		torrent.Announce()
		fmt.Printf("Torrents: %d\n", session.Stats().Torrents)
		fmt.Printf("Downloaded Bytes: %d\n", session.Stats().BytesDownloaded)
		fmt.Printf("Uploaded Bytes: %d\n", session.Stats().BytesUploaded)
		time.Sleep(5 * time.Second)
		fmt.Printf("Torrent Status: %s\n", torrent.Stats().Status)
		fmt.Printf("Torrent Peers Count: %d\n", torrent.Stats().Peers)
	}
}
