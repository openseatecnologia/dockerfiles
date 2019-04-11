FROM alpine:3.9.3

LABEL maintainer="OpenSea Tecnologia u.nu/opn"

ENV GLPIVERSION=9.4.2

# Instalação de depêndencias
RUN apk add --no-cache wget \
openrc \
lighttpd \
php7-common \
php7-iconv \
php7-json \
php7-gd \
php7-curl \
php7-opcache \
php7-apcu \
php7-xml \
php7-imap \
php7-cgi \
fcgi \
php7-pdo \
php7-pdo_pgsql \
php7-soap \
php7-xmlrpc \
php7-posix \
php7-mcrypt \
php7-gettext \
php7-ldap \
php7-ctype \
php7-dom \
php7-mysqli && rm -f /var/cache/apk/*

COPY start.sh /opt/
RUN chmod +x /opt/start.sh
CMD /opt/start.sh
