serve:
	go build main.go && TORRENT_FILES_DIR=$$(pwd)/torrent_files ./main

create_torrents:
	./create-torrents.sh

print_shas:
	ls torrent_files/*.torrent | sed 's/\.torrent$$//' | xargs -n1 -I '{}' find {} -type file | xargs -n1 sha256sum

print_info_hashes:
	ls torrent_files/*.torrent | xargs -n1 transmission-show | grep Hash

packer_build:
	packer build -var "seeder_type=base" packer.json
	packer build -var "seeder_type=magnet" packer.json

ssh_base_seeder_1:
	ssh root@$(shell terraform output -raw base_seeder_ip_1)

ssh_base_seeder_2:
	ssh root@$(shell terraform output -raw base_seeder_ip_2)

ssh_base_seeder_3:
	ssh root@$(shell terraform output -raw base_seeder_ip_3)

ssh_magnet_seeder_1:
	ssh root@$(shell terraform output -raw magnet_seeder_ip_1)

ssh_magnet_seeder_2:
	ssh root@$(shell terraform output -raw magnet_seeder_ip_2)

ssh_magnet_seeder_3:
	ssh root@$(shell terraform output -raw magnet_seeder_ip_3)