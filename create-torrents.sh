#!/bin/sh
set -e 

mktorrent -a http://bittorrent-test-tracker.codecrafters.io/announce -o torrent_files/codercat.gif.torrent torrent_files/codercat.gif/codercat.gif
