serve:
	docker build -t seeder . && docker run -it seeder /bin/ash