# https://github.com/StayPirate/alpine-rtorrent
FROM alpine
ARG GID
ARG UID
# TODO I cannot pass build args on my Synology to Docker, no clue why.
RUN addgroup -g ${GID:-100} -S users \
 && adduser -u ${UID:-1027} -G users -S rtorrent \
 && mkdir /data \
 && chown rtorrent:users /data \
 && apk add --no-cache rtorrent
USER rtorrent:users
WORKDIR /data
CMD ["rtorrent"]
