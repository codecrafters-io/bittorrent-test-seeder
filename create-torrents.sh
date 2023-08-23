#!/bin/sh
set -e

rm -rf torrent_files/*.torrent
mktorrent -d --piece-length=18 -a http://bittorrent-test-tracker.codecrafters.io/announce -o torrent_files/codercat.gif.torrent torrent_files/codercat.gif/codercat.gif
mktorrent -d --piece-length=18 -a http://bittorrent-test-tracker.codecrafters.io/announce -o torrent_files/congratulations.gif.torrent torrent_files/congratulations.gif/congratulations.gif
mktorrent -d --piece-length=18 -a http://bittorrent-test-tracker.codecrafters.io/announce -o torrent_files/itsworking.gif.torrent torrent_files/itsworking.gif/itsworking.gif
