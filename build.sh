#!/usr/bin/env bash

# Names of latest versions of each package
export VERSION_PCRE=pcre-8.41
export VERSION_ZLIB=zlib-1.2.11
export VERSION_LIBRESSL=libressl-2.6.4
export VERSION_NGINX=nginx-1.13.9

# URLs to the source directories
export SOURCE_LIBRESSL=http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/
export SOURCE_PCRE=http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
export SOURCE_NGINX=http://nginx.org/download/
export SOURCE_ZLIB=http://zlib.net/

# Path to local build
export BUILD_DIR=/tmp/nginx-static-libressl/build
# Path for libressl
export STATICLIBSSL="${BUILD_DIR}/${VERSION_LIBRESSL}"

function setup() {
    # create and clean build directory
    mkdir -p ${BUILD_DIR}
    rm -Rf ${BUILD_DIR}/*
    # install build environment tools
    yum -y groupinstall "Development Tools"
}

function download_sources() {
    # todo: verify checksum / integrity of downloads!
    echo "Download sources"

    pushd ${BUILD_DIR}

    curl -sSLO "${SOURCE_ZLIB}${VERSION_ZLIB}.tar.gz"
    curl -sSLO "${SOURCE_PCRE}${VERSION_PCRE}.tar.gz"
    curl -sSLO "${SOURCE_LIBRESSL}${VERSION_LIBRESSL}.tar.gz"
    curl -sSLO "${SOURCE_NGINX}${VERSION_NGINX}.tar.gz"

    popd
}

function extract_sources() {
    echo "Extracting sources"

    pushd ${BUILD_DIR}

    tar -xf "${VERSION_PCRE}.tar.gz"
    tar -xf "${VERSION_LIBRESSL}.tar.gz"
    tar -xf "${VERSION_NGINX}.tar.gz"
    tar -xf "${VERSION_ZLIB}.tar.gz"

    popd
}

function compile_nginx() {
    echo "Configure & Build nginx"

    pushd "${BUILD_DIR}/${VERSION_NGINX}"

    make clean

    ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
        --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
        --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
        --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
        --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
        --pid-path=/run/nginx.pid \
        --lock-path=/run/lock/subsys/nginx \
        --user=nginx \
        --group=nginx \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --without-select_module \
        --without-poll_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-pcre="${BUILD_DIR}/${VERSION_PCRE}" \
        --with-pcre-jit \
        --with-openssl="${STATICLIBSSL}" \
        --with-zlib="${BUILD_DIR}/${VERSION_ZLIB}" \
        --with-cc-opt="-fPIC -pie -O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic" \
        --with-ld-opt="-Wl,-z,now -lrt"

    make -j4

    popd
}

echo "Building ${VERSION_NGINX} with static ${VERSION_LIBRESSL}, ${VERSION_PCRE}, and ${VERSION_ZLIB} ..."

setup && download_sources && extract_sources && compile_nginx

retval=$?
echo ""
if [ $retval -eq 0 ]; then
    echo "Your nginx binary is located at ${BUILD_DIR}/${VERSION_NGINX}/objs/nginx."
    echo "Listing dynamically linked libraries ..."
    ldd ${BUILD_DIR}/${VERSION_NGINX}/objs/nginx
    echo ""
    ${BUILD_DIR}/${VERSION_NGINX}/objs/nginx -V
else
    echo "Ooops, build failed. Check output!"
fi
