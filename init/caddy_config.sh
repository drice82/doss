#!/bin/sh

sed -ri "s/mydomain.me/$MY_DOMAIN/g" /etc/caddy/Caddyfile
