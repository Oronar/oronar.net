FROM alpine:edge as build

RUN apk add --no-cache git openssl py-pygments libc6-compat g++ curl 

ARG HUGO_VERSION="0.115.2"
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz | tar -xz \
    && cp hugo /usr/bin/hugo \
    && apk del curl

COPY ./ /site
WORKDIR /site
RUN hugo

#Copy static files to Nginx
FROM nginx:alpine
COPY --from=build /site/public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
