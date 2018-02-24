Script to build latest Nginx Mainline with latest libressl and gzip support

Based on https://matthiasadler.info/blog/nginx-http2-static-libressl-on-centos-7/ 
(i Updated dependencies)

[pahapoika@xcloud nginx]# nginx -V
nginx version: nginx/1.13.9
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC)
built with LibreSSL 2.6.4
TLS SNI support enabled
configure arguments: --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --pid-path=/run/nginx.pid --lock-path=/run/lock/subsys/nginx --user=nginx --group=nginx --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_slice_module --with-http_stub_status_module --without-select_module --without-poll_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --with-stream --with-stream_ssl_module --with-pcre=/tmp/nginx-static-libressl/build/pcre-8.41 --with-pcre-jit --with-openssl=/tmp/nginx-static-libressl/build/libressl-2.6.4 --with-zlib=/tmp/nginx-static-libressl/build/zlib-1.2.11 --with-cc-opt='-fPIC -pie -O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic' --with-ld-opt='-Wl,-z,now -lrt'


TODO: Replace Gzip with Brotli or add pagespeed module with http2 support