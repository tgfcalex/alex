FROM hub.dawoo.com/core/centos-base

ENV NGINX_USER='nginx' \
    NGINX_UID=800 \
    PATH=/usr/local/nginx/sbin:$PATH

WORKDIR /usr/local/src/

RUN set -ex \
    \
# 创建用户
    && useradd -u ${NGINX_UID} -s /sbin/nologin ${NGINX_USER} \
    && mkdir -p /data/nginx/{logs,tmps} \
    && chown -R ${NGINX_USER}: /data/nginx/ \
    \
# IP地理位置定位组件 GeoIP-devel
    && yum install -y \
        autoconf \
        file \
        gcc \
        gcc-c++ \
        make \
        patch \
        gd-devel \
        libxslt-devel \
        perl-devel \
        perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed \
        zlib-devel \
    \
# 1. 编译安装 libunwind 内存管理库
    && tmp_URL='http://download.savannah.nongnu.org/releases/libunwind/libunwind-1.1.tar.gz' \
    && tmp_NAME='libunwind' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME} && LAGS=-fPIC ./configure --prefix=/usr \
        && make LAGS=-fPIC && make LAGS=-fPIC install ) \
    \
# 2. 编译安装 pcre 正则库
    && tmp_URL='https://sourceforge.net/projects/pcre/files/pcre/8.40/pcre-8.40.tar.gz' \
    && tmp_NAME='pcre' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME} && LAGS=-fPIC ./configure --prefix=/usr \
        && make LAGS=-fPIC && make LAGS=-fPIC install ) \
    \
# 3. 编译安装 OpenSSL库
#    && tmp_URL='https://www.openssl.org/source/old/1.0.1/openssl-1.0.1g.tar.gz' \
    && tmp_URL='https://www.openssl.org/source/old/1.0.2/openssl-1.0.2.tar.gz' \
    && tmp_NAME='openssl' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME} && ./config shared --prefix=/usr \
        && make && make install ) \
    \
# 4. IP地理位置定位组件 GeoIP
    && tmp_URL='https://github.com/maxmind/geoip-api-c/releases/download/v1.6.10/GeoIP-1.6.10.tar.gz' \
    && tmp_NAME='GeoIP' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME} && ./configure --prefix=/usr \
        && make && make install ) \
    \
# 5. 编译安装 gperftools
    && tmp_URL='https://github.com/gperftools/gperftools/releases/download/gperftools-2.5/gperftools-2.5.tar.gz' \
    && tmp_NAME='gperftools' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME} && ./configure --prefix=/usr \
        && make && make install ) \
    \
# 6. 编译安装 libmaxminddb依赖库。
# libmaxminddb是一个C库文件，用于读取MaxMind DB文件，包括MaxMind下的GeoIP2数据文件。
    && tmp_URL='https://github.com/maxmind/libmaxminddb/releases/download/1.1.5/libmaxminddb-1.1.5.tar.gz' \
    && tmp_NAME='libmaxminddb' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME} && ./configure --prefix=/usr \
        && make && make install ) \
    \
# 编译安装 jemalloc 无需XSL
    && tmp_URL='https://github.com/jemalloc/jemalloc/archive/4.5.0.tar.gz' \
    && tmp_NAME='jemalloc' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME} && ./autogen.sh --prefix=/usr \
        && make && make install_bin install_include install_lib ) \
    \
# 编译安装 LuaJIT
    && tmp_URL='http://luajit.org/download/LuaJIT-2.0.4.tar.gz' \
    && tmp_NAME='LuaJIT' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ${tmp_NAME}  \
        && make && make install ) \
    \
    \
    \
# 添加编译库路径
    && sh -c "echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf" \
    && sh -c "echo /usr/local/lib64  >> /etc/ld.so.conf.d/local.conf" \
    && ldconfig \
    && rm -rf /usr/local/src/* \
    \
# 下载Tengine缓存刷新模块 ngx_cache_purge
    && ngx_cache_purge_URL='https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz' \
    && curl -SL ${ngx_cache_purge_URL}  -o ngx_cache_purge.tar.gz \
    && mkdir ngx_cache_purge \
    && tar -xzf ngx_cache_purge.tar.gz -C ./ngx_cache_purge --strip-components=1 \
    \
# 采用hmux协议访问resin服务器，以提高访问性能,此模块相当于apache的mod_caucho模块
    && nginx_hmux_module_URL='https://github.com/wangbin579/nginx-hmux-module/archive/v1.4.tar.gz' \
    && curl -SL ${nginx_hmux_module_URL}  -o nginx_hmux_module.tar.gz \
    && mkdir nginx_hmux_module \
    && tar -xzf nginx_hmux_module.tar.gz -C ./nginx_hmux_module --strip-components=1 \
    \
# GeoIP2的拓展模块处理不同国家的访问
    && ngx_http_geoip2_module_URL='https://github.com/leev/ngx_http_geoip2_module/archive/2.0.tar.gz' \
    && curl -SL ${ngx_http_geoip2_module_URL}  -o ngx_http_geoip2_module.tar.gz \
    && mkdir ngx_http_geoip2_module \
    && tar -xzf ngx_http_geoip2_module.tar.gz -C ./ngx_http_geoip2_module --strip-components=1 \
    \
## nginx tcp代理功能由nginx_tcp_proxy_module模块提供，同时监测后端主机状态
    && nginx_tcp_proxy_module_URL='https://github.com/yaoweibin/nginx_tcp_proxy_module/archive/master.zip' \
    && curl -SL ${nginx_tcp_proxy_module_URL}  -o nginx_tcp_proxy_module.zip \
    && unzip -q -o nginx_tcp_proxy_module.zip \
    \
    \
# 编译安装 tengine
#&& tmp_URL='http://tengine.taobao.org/download/tengine-2.2.0.tar.gz' \
    && tmp_URL='http://tengine.taobao.org/download/tengine-2.1.1.tar.gz' \
    && tmp_NAME='tengine' \
    && curl -SL ${tmp_URL}  -o ${tmp_NAME}.tar.gz \
    && mkdir ${tmp_NAME} \
    && tar -xzf ${tmp_NAME}.tar.gz -C ./${tmp_NAME} --strip-components=1 \
    && ( cd ./${tmp_NAME} \
        && patch -p1 < /usr/local/src/nginx_tcp_proxy_module-master/tcp.patch \
        &&./configure  \
            --prefix=/usr/local/nginx \
            --pid-path=/var/run/nginx.pid \
            --http-log-path=/data/nginx/logs/access.log \
            --error-log-path=/data/nginx/logs/error.log \
            --http-client-body-temp-path=/data/nginx/tmps/nginx_client \
            --http-fastcgi-temp-path=/data/nginx/tmps/nginx_fastcgi \
            --http-proxy-temp-path=/data/nginx/tmps/nginx_proxy \
            \
            --add-module=/usr/local/src/nginx_hmux_module \
            --add-module=/usr/local/src/nginx_tcp_proxy_module-master \
            --add-module=/usr/local/src/ngx_cache_purge \
            --add-module=/usr/local/src/ngx_http_geoip2_module \
            \
            --with-backtrace_module \
            --with-google_perftools_module \
            --with-jemalloc \
            --with-http_access_module=shared \
            --with-http_addition_module=shared \
            --with-http_browser_module=shared \
            --with-http_charset_filter_module=shared \
            --with-http_concat_module=shared \
            --with-http_empty_gif_module=shared \
            --with-http_footer_filter_module=shared \
            --with-http_gzip_static_module \
            --with-http_image_filter_module=shared \
            --with-http_limit_conn_module=shared \
            --with-http_limit_req_module=shared \
            --with-http_lua_module \
            --with-http_map_module=shared \
            --with-http_memcached_module=shared \
            --with-http_realip_module \
            --with-http_referer_module=shared \
            --with-http_rewrite_module=shared \
            --with-http_split_clients_module=shared \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_sub_module=shared \
            --with-http_sysguard_module=shared \
            --with-http_upstream_check_module \
            --with-http_upstream_ip_hash_module=shared \
            --with-http_upstream_least_conn_module=shared \
            --with-http_upstream_session_sticky_module=shared \
            --with-http_user_agent_module=shared \
            --with-http_userid_filter_module=shared \
            --with-http_xslt_module=shared \
            --with-ld-opt=-ltcmalloc_minimal \
            --with-luajit-inc=/usr/local/include/luajit-2.0 \
            --with-luajit-lib=/usr/local/lib \
            --with-md5=/usr/lib \
            --with-pcre \
            --with-openssl-opt=-fPIC \
            --without-http_scgi_module \
            --without-http_uwsgi_module \
            --without-poll_module \
            --without-select_module \
        \
        && sed -i '/^CFLAGS\ =/s@-DNDK_SET_VAR@-Wno-unused-parameter -DNDK_SET_VAR@' /usr/local/src/tengine/objs/Makefile \
        && make -j$(getconf _NPROCESSORS_ONLN) \
        && make install ) \
    \
    && ln -sv /usr/local/nginx/conf /etc/nginx \
    \
# set nginx.conf syntax hightlight
    && mkdir -p ~/.vim/syntax/ \
    && curl -SL http://www.vim.org/scripts/download_script.php?src_id=14376 \
        -o ~/.vim/syntax/nginx.vim \
    && echo "au BufRead,BufNewFile */nginx/* set ft=nginx" \
        >> ~/.vim/filetype.vim \
    \
    && yum remove -y autoconf file gcc gcc-c++ make patch \
    && rm -rf /usr/local/src/* \
    && yum clean all

