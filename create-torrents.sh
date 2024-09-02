#!/bin/sh
set -e

rm -rf torrent_files/**/*.torrent

for seeder_type in base magnet; do
    for folder in torrent_files/$seeder_type/*; do
        if [ ! -d "$folder" ]; then
            continue
        fi

        file=$(basename "$folder")

        if [ "$file" = "sample.txt" ]; then
            piece_length=15
        else
            piece_length=18
        fi

        mktorrent -d --piece-length=$piece_length -a http://bittorrent-test-tracker.codecrafters.io/announce -o torrent_files/$seeder_type/$file.torrent torrent_files/$seeder_type/$file/$file
    done
done

rm -rf torrent_files/magnet_links.txt

for file in torrent_files/magnet/*.torrent; do
    echo "$(basename $file): $(transmission-show -m $file)" >>torrent_files/magnet_links.txt
done
