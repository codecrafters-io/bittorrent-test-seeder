serve:
	go build main.go && ./main

print_shas:
	ls torrent_files/*.gif/*.gif | xargs -n1 sha256sum

print_info_hashes:
	ls torrent_files/*.torrent | xargs -n1 transmission-show | grep Hash