FROM klakegg/hugo:debian

RUN mkdir target

COPY content/ target/
RUN hugo --minify
