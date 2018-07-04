FROM alpine:3.7

ARG VERSION
ARG RTORRENT_V=0.9.7
ARG LIBTORRENT_V=0.13.7

LABEL maintainer="zgist" \
        org.label-schema.name="RTorrent" \
        org.label-schema.version=$VERSION

ENV USERNAME        admin
ENV PASSWORD=
ENV UID             1000
ENV GID             1000

# Let's roll
RUN set -xe && \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        build-base \
        curl-dev \
        git \
        libressl-dev \
        libsigc++-dev \
        libtool \
        linux-headers \
        xmlrpc-c-dev \
        ncurses-dev \
        zlib-dev && \
    apk add --no-cache --virtual .run-deps \
        apache2-utils \
        ca-certificates \
        libcurl \
        libgcc \
        libressl2.6-libcrypto \
        libstdc++ \
        musl \
        ncurses-libs \
        nginx \
        php7 \
        php7-fpm \
        php7-json \
        supervisor \
        xmlrpc-c \
        zlib && \
    apk add --no-cache --virtual .plug-deps \
        curl \
        ffmpeg \
        mediainfo \
        mktorrent \
        sox \
        unrar \
        unzip \
        zip && \
    # libtorrent
    mkdir /tmp/libtorrent && cd /tmp/libtorrent && \
    curl -sSL https://github.com/rakshasa/libtorrent/archive/v$LIBTORRENT_V.tar.gz | tar xz --strip 1 && \
    ./autogen.sh && \
    ./configure --prefix=/usr \
                --disable-debug \
                --disable-instrumentation && \
    make clean && make install && \
    # rtorrent
    mkdir /tmp/rtorrent && cd /tmp/rtorrent && \
    curl -sSL https://github.com/rakshasa/rtorrent/archive/v$RTORRENT_V.tar.gz | tar xz --strip 1 && \
    ./autogen.sh && \
    ./configure --prefix=/usr \
                --sysconfdir=/etc \
                --mandir=/usr/share/man \
                --localstatedir=/var \
                --enable-ipv6 \
                --disable-debug \
                --with-xmlrpc-c && \
    make install && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/lib/libtorrent.la /usr/bin/rtorrent \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual runDeps && \
    # rutorrent
    git clone https://github.com/Novik/ruTorrent.git /var/www/rutorrent && \
    # clean
    apk del .build-deps && \
    rm -rf /var/www/rutorrent/.git* /tmp/rtorrent /tmp/libtorrent

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY supervisord.ini /etc/supervisor.d/supervisord.ini
COPY rtorrent.rc /etc/rtorrent.rc
COPY rutorrent /var/www/rutorrent
COPY etc /etc

VOLUME /download

EXPOSE 8080 55000

CMD ["/usr/bin/entrypoint.sh"]
