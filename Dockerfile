FROM klakegg/hugo:debian

COPY . .
RUN hugo --minify
