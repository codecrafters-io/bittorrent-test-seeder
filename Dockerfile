FROM golang:alpine

ADD main.go /app/main.go
ADD go.mod /app/go.mod
ADD go.sum /app/go.sum

RUN cd /app && go build -o seeder && mv seeder /bin/seeder

ADD torrent_files /etc/torrent_files

CMD ["/bin/seeder"]