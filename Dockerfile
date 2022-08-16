FROM nginx:1.22-alpine AS builder

ENV NCHAN_VERSION 1.2.5

RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
    apk add --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    curl \
    gnupg \
    libxslt-dev \
    gd-dev \
    geoip-dev && \
    curl -L --output nchan.tar.gz "https://github.com/slact/nchan/archive/v${NCHAN_VERSION}.tar.gz"

RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    mkdir -p /usr/src && \
    tar -zxC /usr/src -f nginx.tar.gz && \
    tar -xzvf "nchan.tar.gz" && \
    NCHANDIR="$(pwd)/nchan-${NCHAN_VERSION}" && \
    cd /usr/src/nginx-$NGINX_VERSION && \
    ./configure --with-compat $CONFARGS --add-dynamic-module=$NCHANDIR && \
    make && make install

FROM nginx:1.22-alpine

COPY --from=builder /usr/local/nginx/modules/ngx_nchan_module.so /usr/local/nginx/modules/ngx_nchan_module.so

RUN apk add --update \
    apache2-utils=2.4.53-r0 \
    bash \
    apk-tools \
    busybox \
    curl \
    libcurl \
    libcrypto1.1 \
    libssl1.1 \
    libjpeg-turbo \
    && rm -f /etc/nginx/conf.d/default.conf \
    && rm -rf /var/cache/apk/*

COPY nginx.conf /etc/nginx/
