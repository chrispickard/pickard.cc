FROM klakegg/hugo:debian as hugo

COPY . .
RUN hugo --minify

FROM caddy
COPY Caddyfile /etc/caddy/
COPY --from=hugo public/* /var/www/html
