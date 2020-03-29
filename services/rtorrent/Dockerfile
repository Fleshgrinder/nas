# https://github.com/StayPirate/alpine-rtorrent
FROM alpine
ARG GID
ARG UID
RUN addgroup -g $GID -S rtorrent \
 && adduser -u $UID -G rtorrent -S rtorrent \
 && mkdir /data \
 && chown rtorrent:rtorrent /data \
 && apk add --no-cache rtorrent
USER rtorrent:rtorrent
WORKDIR /data
CMD ["rtorrent"]
