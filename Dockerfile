FROM nginx:1.23.2-alpine

RUN apk add --update --no-cache \
    bash \
    supervisor \
    tzdata \
    openssl

COPY bin/consul-template /usr/local/bin/consul-template
COPY bin/serve-tools /usr/local/bin/serve-tools

RUN rm -rf /etc/nginx/conf.d/*

ENV NGINX_LISTEN_PORT "80"
ENV NGINX_SSL_PORT "443"
ENV NGINX_ACCESS_LOG "/dev/stdout json"
ENV NGINX_STAGING_IP "0.0.0.0"

ENV SERVE_ROUTE_FILTERS ""
ENV CONSUL_HTTP_ADDR "127.0.0.1:8500"
ENV TIMEZONE "UTC"

ENTRYPOINT ["/run/entrypoint.sh"]

VOLUME ["/cache/nginx", "/etc/nginx/include.d", "/etc/nginx/conf.d", "/etc/nginx/ssl", "/var/cache/nginx/"]

COPY default-ssl.crt default-ssl.key /etc/nginx/
COPY entrypoint.sh /run/entrypoint.sh
COPY consul-template.conf /etc/consul/consul-template.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY consul-tcp-streams.ctmpl /etc/consul/consul-tcp-streams.ctmpl
COPY consul-sites.ctmpl /etc/consul/consul-sites.ctmpl

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
