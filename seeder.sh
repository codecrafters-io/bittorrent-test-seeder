#!/bin/sh
set -e
exec transmission-cli /etc/torrent_files/congratulations.gif.torrent -w /etc/torrent_files -p 51413
