serve:
	go build main.go && ./main

print_shas:
	ls torrent_files/*.gif/*.gif | xargs -n1 sha256sum