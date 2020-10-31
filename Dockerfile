FROM alpine:latest

MAINTAINER Jason Schulte <jasonschulte@gmail.com>
LABEL description='Webmin + Bind9 on Alpine'

# CREDITS
# https://github.com/sameersbn/docker-bind
# https://github.com/maxid/webmin-alpine

ARG WEBMIN_VERSION=1.941

COPY config/webmin.exp /

### Update packages
RUN apk --update upgrade && apk add curl && \
### Install packages
    apk add ca-certificates openssl perl perl-net-ssleay apkbuild-cpan expect bind bash && \
### Install & Configure webmin
    mkdir -p /opt && cd /opt && \
    wget -q -O - "https://prdownloads.sourceforge.net/webadmin/webmin-${WEBMIN_VERSION}.tar.gz" | tar xz && \
    ln -sf /opt/webmin-${WEBMIN_VERSION} /opt/webmin && \
    /usr/bin/expect /webmin.exp && rm /webmin.exp && \
### Create bind cache dir
    mkdir -p /var/cache/bind && \
### Clean packages cache
    rm -rf /var/cache/apk/*


COPY config/bind /etc/bind
COPY config/webmin/bind_config /etc/webmin/bind8/config

RUN chown -R root:bin /etc/webmin && \
    chown -R root:named /etc/bind && chown root:named /var/cache/bind 

ENV SHELL /bin/bash

EXPOSE 53/udp 53/tcp 953 10000

VOLUME ["/etc/bind"]

COPY entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
