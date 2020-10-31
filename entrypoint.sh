#!/bin/bash
set -e
exec /usr/sbin/named -c /etc/bind/named.conf -g &
/etc/webmin/start --nofork
