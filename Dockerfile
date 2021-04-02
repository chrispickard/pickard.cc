FROM klakegg/hugo:debian as hugo

COPY . .
RUN hugo --minify

FROM caddy
RUN mkdir -p /var/www/html
COPY Caddyfile /etc/caddy/
COPY --from=hugo /src/public /var/www/html
