FROM centos:7

#ADD https://github.com/krallin/tini/releases/download/v0.17.0/tini /usr/bin/tini
RUN \
  set -ex \

# ------------------------------------------------- centos-base start -------------------------------------------------
# add yum repo: epel
  &&  yum install -y epel-release.noarch \
  \
# install tool
  && yum clean all; yum update -y \
  && yum install -y \
    iproute net-tools telnet cronie crontabs tree \
    vim unzip which tree file nmap nmap-ncat less \
    traceroute mlocate bash-completion bash-completion-extras openssh-clients \
  \


# install supervisor & lsyncd & redis
  && yum install -y python-pip lsyncd redis \
  && pip install --upgrade pip \
  && pip install --upgrade supervisor requests redis setuptools \
  \
  && supervisord -v \
  && lsyncd --version \
  && pip list \
  \

# ------------------------------------------------- centos-base end -------------------------------------------------
# ------------------------------------------------- install nginx start -------------------------------------------------
  && _CONFIG_OPTIONS="\
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    " \
  && _CONFIG_J=`getconf _NPROCESSORS_ONLN` \

# Install dependencies
  && yum install -y \
    gd-devel \
    GeoIP-devel \
    jemalloc-devel \
    libmaxminddb-devel \
    libunwind-devel \
    libxml2-devel \
    libxslt-devel \
    perl-devel \
    perl-ExtUtils-Embed \
    python-devel \
    readline-devel \
    zlib-devel \
    lua-devel lua-static \
    sysvinit-tools \
  && yum history new \
  && yum install -y gcc git gcc-c++ make file patch \
  \
  && cd /usr/local/src/ \

# mkdir /var/logs/nginx/logs/ /var/logs/nginx/tmps
  && mkdir -p /var/data/nginx/tmps/{nginx_client,nginx_proxy,nginx_fastcgi} \
  && _CONFIG_DIR="\
    --error-log-path=/var/logs/nginx/error.log \
    --http-log-path=/var/logs/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --http-client-body-temp-path=/var/data/nginx/tmps/nginx_client \
    --http-proxy-temp-path=/var/data/nginx/tmps/nginx_proxy \
    --http-fastcgi-temp-path=/var/data/nginx/tmps/nginx_fastcgi \
    " \

# Add-module: ngx_cache_purge GeoIP2 nginx_upstream_check_module nginx-sticky-module
# 缓存刷新模块 ngx_cache_purge
  && tmp_URL='https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz' \
  && tmp_NAME='ngx_cache_purge.tar.gz' \
  && tmp_DIR='/usr/local/src/ngx_cache_purge' \
  \
  && curl -SL $tmp_URL -o $tmp_NAME \
  && mkdir -p $tmp_DIR \
  && tar --strip-components=1 \
    -xzf $tmp_NAME -C $tmp_DIR \
  \

# GeoIP2的拓展模块处理不同国家的访问
  && tmp_URL='https://github.com/leev/ngx_http_geoip2_module/archive/2.0.tar.gz' \
  && tmp_NAME='ngx_http_geoip2_module.tar.gz' \
  && tmp_DIR='/usr/local/src/ngx_http_geoip2_module' \
  \
  && curl -SL $tmp_URL -o $tmp_NAME \
  && mkdir -p $tmp_DIR \
  && tar --strip-components=1 \
    -xzf $tmp_NAME -C $tmp_DIR \
  \

# nginx_upstream_check_module 健康检测 upstream
  && tmp_URL='https://github.com/yaoweibin/nginx_upstream_check_module.git' \
  && tmp_DIR='/usr/local/src/nginx_upstream_check_module' \
  \
  && git clone $tmp_URL $tmp_DIR \
  \

# nginx-sticky-module 会话保持
  && tmp_URL='https://mcompany@bitbucket.org/nginx-goodies/nginx-sticky-module-ng.git' \
  && tmp_DIR='/usr/local/src/nginx-sticky-module' \
  \
  && git clone $tmp_URL $tmp_DIR \
  && (cd $tmp_DIR \
    && patch -p0 < /usr/local/src/nginx_upstream_check_module/nginx-sticky-module.patch \
  ) \

# nginx-upstream-fair upstream 均衡
  && tmp_URL='https://github.com/gnosek/nginx-upstream-fair.git' \
  && tmp_DIR='/usr/local/src/nginx-upstream-fair' \
  \
  && git clone $tmp_URL $tmp_DIR \
  && (cd $tmp_DIR \
    && patch -p1 < /usr/local/src/nginx_upstream_check_module/upstream_fair.patch \
  ) \
 #修改upstream_fair源码，要不然openrestry编译会报错
  && sed -i 's/\&& us->default_port == 0//g'  /usr/local/src/nginx-upstream-fair/ngx_http_upstream_fair_module.c \
  && sed -i 's/u.port = (in_port_t) (us->port ? us->port : us->default_port)/u.port = us->port/g' /usr/local/src/nginx-upstream-fair/ngx_http_upstream_fair_module.c \
  && _CONFIG_ADDS="\
    --add-module=/usr/local/src/nginx_upstream_check_module \
    --add-module=/usr/local/src/nginx-sticky-module \
    --add-module=/usr/local/src/nginx-upstream-fair \
    --add-module=/usr/local/src/ngx_http_geoip2_module \
    --add-module=/usr/local/src/ngx_cache_purge \
    " \

# Download and untar OpenSSL, PCRE, and OpenResty
# 注意: --with-pcre, --with-openssl, --with-zlib, --with-md5, --with-sha1 指定的是源代码目录，不是这些类库的安装目录,无需编译安装
# 1. OpenSSL库 => /usr/local/src/openssl
  && tmp_URL='https://www.openssl.org/source/old/1.0.2/openssl-1.0.2l.tar.gz' \
  && tmp_NAME='openssl.tar.gz' \
  && tmp_DIR='/usr/local/src/openssl' \
  \
  && curl -SL $tmp_URL -o $tmp_NAME \
  && mkdir -p $tmp_DIR \
  && tar --strip-components=1 \
    -xzf $tmp_NAME -C $tmp_DIR \
  \

# 2. pcre 正则库 => /usr/local/src/pcre
  && tmp_URL='https://ftp.pcre.org/pub/pcre/pcre-8.39.tar.gz' \
  && tmp_NAME='pcre.tar.gz' \
  && tmp_DIR='/usr/local/src/pcre' \
  \
  && curl -SL $tmp_URL -o $tmp_NAME \
  && mkdir -p $tmp_DIR \
  && tar --strip-components=1 \
    -xzf $tmp_NAME -C $tmp_DIR \
  \

# These are not intended to be user-specified
  && _CONFIG_DEPS="\
    --with-openssl=/usr/local/src/openssl \
    --with-pcre=/usr/local/src/pcre \
    " \

# openresty 1.11.2.5 update to 1.13.6.2 ==> By Sun
  && tmp_URL='https://openresty.org/download/openresty-1.13.6.2.tar.gz' \
  && tmp_NAME='openresty.tar.gz' \
  && tmp_DIR='/usr/local/src/openresty' \
  \
  && curl -SL $tmp_URL -o $tmp_NAME \
  && mkdir -p $tmp_DIR \
  && tar  --strip-components=1 \
    -xzf $tmp_NAME -C $tmp_DIR \
  \
  && ( \
    cd ${tmp_DIR}/bundle/nginx-1.13.6 \
    && patch -p0 < /usr/local/src/nginx_upstream_check_module/check_1.11.5+.patch \
  )\
  && ( \
    cd $tmp_DIR \
    && ./configure ${_CONFIG_DIR} ${_CONFIG_DEPS} ${_CONFIG_OPTIONS} ${_CONFIG_ADDS} \
    && make -j ${_CONFIG_J:-4} \
    && make -j ${_CONFIG_J:-4} install \
  ) \

# luarocks
  && tmp_URL='http://luarocks.github.io/luarocks/releases/luarocks-2.4.3.tar.gz' \
  && tmp_NAME='luarocks.tar.gz' \
  && tmp_DIR='/usr/local/src/luarocks' \
  \
  && curl -SL $tmp_URL -o $tmp_NAME \
  && mkdir -p $tmp_DIR \
  && tar --strip-components=1 \
    -xzf $tmp_NAME  -C $tmp_DIR \
  \
  && ( \
    cd $tmp_DIR \
    && ./configure \
      --prefix=/usr/local/openresty/luajit \
      --with-lua=/usr/local/openresty/luajit \
      --lua-suffix=jit-2.1.0-beta3 \
      --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make build \
    && make install \
  ) \
  && ln -sv /usr/local/openresty/nginx/ /usr/local/nginx \
  && ln -sv /var/logs/nginx /usr/local/openresty/nginx/logs \
  && ln -svf /usr/local/nginx/logs/access.log /usr/local/nginx/ \
  && ln -svf /usr/local/nginx/logs/error.log /usr/local/nginx/ \

# set nginx.conf syntax hightlight
  #&& mkdir -p ~/.vim/syntax/ \
  #&& curl -SL http://www.vim.org/scripts/download_script.php?src_id=14376 \
  #  -o ~/.vim/syntax/nginx.vim \
  #&& echo "au BufRead,BufNewFile *nginx*/*.conf* set ft=nginx" \
  #  >> ~/.vim/filetype.vim \
  #\

# clean
  && rm -rf /root/.cache/pip/* \
  && rm -rf /usr/local/src/* \
  && yum history -y undo 1 \
  && yum clean all

# ------------------------------------------------- install nginx end -------------------------------------------------
ADD  container-files /
# Add additional binaries into PATH for convenience
ENV PATH=/usr/local/openresty/luajit/bin/:/usr/local/openresty/nginx/sbin/:/usr/local/openresty/bin/:$PATH
WORKDIR /usr/local/nginx/
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]