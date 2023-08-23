package main

import (
	"fmt"
	"math/rand"
	"os"
	"path/filepath"
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
	config.PortEnd = 51500
	config.PEXEnabled = false
	config.RPCEnabled = false
	config.DHTEnabled = false

	println(config.Database)

	session, err := torrent.NewSession(config)
	if err != nil {
		panic(err)
	}

	torrents := []*torrent.Torrent{}

	// List all files that match the pattern /etc/torrent_files/*.torrent
	filePaths, err := filepath.Glob("/etc/torrent_files/*.torrent")
	if err != nil {
		panic(err)
	}

	for _, filePath := range filePaths {
		torrentName := filepath.Base(filePath)                       // congratulations.gif.torrent
		torrentName = torrentName[:len(torrentName)-len(".torrent")] // congratulations.gif

		file, err := os.Open(filePath)
		if err != nil {
			panic(err)
		}

		torrent, err := session.AddTorrent(file, &torrent.AddTorrentOptions{ID: torrentName})
		if err != nil {
			panic(err)
		}

		torrents = append(torrents, torrent)
	}

	for {
		fmt.Printf("Torrents: %d, Downloaded: %dB, Uploaded: %dB\n", session.Stats().Torrents, session.Stats().BytesDownloaded, session.Stats().BytesUploaded)

		for _, torrent := range torrents {
			torrent.Announce()
			fmt.Printf("[%s] Status: %s, Peers Count: %d\n", torrent.ID(), torrent.Stats().Status, torrent.Stats().Peers.Total)
		}

		time.Sleep(10 * time.Second)
	}
}
