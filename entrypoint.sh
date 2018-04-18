#!/bin/bash -ex

sed -i -- 's/NGINX_LISTEN_PORT/'${NGINX_LISTEN_PORT}'/g' /etc/nginx/nginx.conf

exec "$@"
