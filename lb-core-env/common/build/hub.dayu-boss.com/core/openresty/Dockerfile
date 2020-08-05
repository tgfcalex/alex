FROM hub.dayu-boss.com/core/centos-openresty-1.11.2.5

ADD container-files /
RUN \
  set -ex \
  && yum install -y GraphicsMagick \
  && yum clean all \
  && chmod +x /usr/bin/{cut-ngx-log,reload-ngx,start,stop}.sh \
  && ln -sv /usr/bin/reload-ngx{.sh,}

WORKDIR /usr/local/openresty/nginx/

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=10s --retries=6 \
          CMD port_check 80
