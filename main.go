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
	// config.Host = "159.89.251.24"

	// Random database name every time
	rand.Seed(time.Now().UnixNano())
	config.Database = fmt.Sprintf("/tmp/database/%d", rand.Int())
	config.DataDir = "/etc/torrent_files"

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
		fmt.Printf("Torrents: %d, Downloaded: %dB, Uploaded: %dB\n", session.Stats().Torrents, session.Stats().BytesDownloaded, session.Stats().BytesUploaded)
		fmt.Printf("Torrent Status: %s, Peers Count: %d\n", torrent.Stats().Status, torrent.Stats().Peers.Total)
		time.Sleep(10 * time.Second)
	}
}
