#!/bin/bash -ex

function replace_conf {
  find /etc/nginx/ -name "*.conf" -type f -exec sed -i -- "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo ${!1} | sed -e 's/[\/&]/\\&/g')/g" {} \;
}

replace_conf NGINX_LISTEN_PORT
replace_conf NGINX_SSL_PORT
replace_conf NGINX_ACCESS_LOG


cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo ${TIMEZONE} > /etc/timezone

mkdir -p /etc/nginx/ssl

# generate dhparams.pem
if [ ! -f /etc/nginx/ssl/dhparams.pem ]; then
  echo "make dhparams"
  pushd /etc/nginx/ssl
  openssl dhparam -out dhparams.pem 2048
  chmod 600 dhparams.pem
  popd
fi

exec "$@"
