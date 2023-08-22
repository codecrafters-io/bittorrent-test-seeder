#!/bin/sh
set -e
# exec transmission-cli /etc/torrent_files/congratulations.gif.torrent -w /etc/torrent_files -p 51413
exec aria2c \
    -V \
    --seed-time=0 \
    --listen-port=51413 \
    --enable-dht=false \
    --enable-peer-exchange=false \
    --bt-enable-lpd=false \
    --bt-external-ip="137.66.12.135" \
    -d /etc/torrent_files \
    /etc/torrent_files/congratulations.gif.torrent
