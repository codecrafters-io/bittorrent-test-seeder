#!/bin/sh
set -e

rm -rf torrent_files/*.torrent
rm -rf torrent_files/magnet_links.txt

for folder in torrent_files/*; do
    if [ ! -d "$folder" ]; then
        continue
    fi

    file=$(basename "$folder")

    if [ "$file" = "sample.txt" ]; then
        piece_length=15
    else
        piece_length=18
    fi

    mktorrent -d --piece-length=$piece_length -a http://bittorrent-test-tracker.codecrafters.io/announce -o torrent_files/$file.torrent torrent_files/$file/$file
    echo "$file: $(transmission-show -m torrent_files/$file.torrent)" >> torrent_files/magnet_links.txt
done
