FROM alpine:latest

RUN apk add --no-cache transmission-cli
RUN apk add --no-cache aria2

ADD torrent_files /etc/torrent_files
# ADD transmission-settings.json /root/.config/transmission/settings.json
# ADD seeder.sh /bin/seeder.sh

CMD ["/bin/seeder.sh"]