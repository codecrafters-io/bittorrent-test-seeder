package main

import (
	"fmt"
	"math/rand"
	"os"
	"path"
	"path/filepath"
	"time"

	"github.com/cenkalti/rain/torrent"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: ./main <seeder_type> (seeder_type is base/magnet)")
		os.Exit(1)
	}

	seederType := os.Args[1]

	if seederType != "base" && seederType != "magnet" {
		fmt.Println("Usage: ./main <seeder_type> (seeder_type is base/magnet)")
		os.Exit(1)
	}

	config := torrent.DefaultConfig
	config.ExtensionProtocolEnabled = (seederType != "base")

	fmt.Printf("Seeder type: %s (extension protocol enabled: %t)\n", seederType, config.ExtensionProtocolEnabled)

	// Random database name every time
	rand.Seed(time.Now().UnixNano())
	config.Database = fmt.Sprintf("/tmp/database/%d", rand.Int())

	dataDir := os.Getenv("TORRENT_FILES_DIR")
	if dataDir == "" {
		dataDir = "/etc/torrent_files"
	}

	fmt.Printf("DataDir: %s\n", dataDir)

	config.DataDir = dataDir
	config.Debug = true

	config.PortBegin = 51413
	config.PortEnd = 51600
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

	filePaths, err := filepath.Glob(path.Join(dataDir, "*.torrent"))
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
