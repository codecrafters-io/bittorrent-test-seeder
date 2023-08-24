serve:
	go build main.go && TORRENT_FILES_DIR=$$(pwd)/torrent_files ./main

create_torrents:
	./create-torrents.sh

print_shas:
	ls torrent_files/*.torrent | sed 's/\.torrent$$//' | xargs -n1 -I '{}' find {} -type file | xargs -n1 sha256sum

print_info_hashes:
	ls torrent_files/*.torrent | xargs -n1 transmission-show | grep Hash

packer_build:
	packer build packer.json