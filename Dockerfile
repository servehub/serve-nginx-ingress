FROM nginx:1.12-alpine

RUN apk add --no-cache bash supervisor

COPY bin/consul-template /usr/local/bin/consul-template
COPY bin/serve-tools /usr/local/bin/serve-tools

ENV NGINX_LISTEN_PORT "80"
ENV SERVE_ROUTE_FILTERS ""
ENV CONSUL_HTTP_ADDR "127.0.0.1:8500"

VOLUME ["/cache/nginx"]

EXPOSE 80

COPY consul-template.conf /etc/consul/consul-template.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY consul-nginx.ctmpl /etc/consul/consul-nginx.ctmpl

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
