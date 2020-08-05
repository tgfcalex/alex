FROM hub.dayu-boss.com/core/centos-base

ENV REDIS_VERSION=3.2.11

RUN set -ex \
  \
  && redis_user=redis \
  && redis_uid=996 \
  && groupadd -g $redis_uid $redis_user \
  && useradd -s /sbin/nologin -g $redis_uid -u $redis_uid $redis_user \
  \
  && yum install -y tcl-devel ruby-devel rubygems-devel ca-certificates libxslt-devel \
  && yum history new \
  && yum install -y gcc gcc-c++ make \
  \
  && redis_url='http://download.redis.io/releases/redis-3.2.11.tar.gz' \
  && redis_sha1='ca726709eca5b704ac645a6626997430345ac16e' \
  && redis_app='redis.tar.gz' \
  && src_dir='/usr/local/src/redis/' \
  \
  && curl  -o ${redis_app} -SL "$redis_url" \
  && echo "$redis_sha1 ${redis_app}" | sha1sum -c - \
  && mkdir -p ${src_dir} \
  && tar -xzf ${redis_app}  -C ${src_dir} --strip-components=1 \
  && rm -f ${redis_app}  \

# sable Redis protected mode [1] as it is unnecessary in context
# of Docker. Ports are not automatically exposed when running inside
# Docker, but rather explicitely by specifying -p / -P.
# [1] https://github.com/antirez/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
  && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' ${src_dir}/src/server.h \
  && sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' ${src_dir}/src/server.h \
  && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' ${src_dir}/src/server.h \

# for future reference, we modify this directly in the source instead of just supplying a default configuration flag because apparently "if you specify any argument to redis-server, [it assumes] you are going to specify everything"
# see also https://github.com/docker-library/redis/issues/4#issuecomment-50780840
# (more exactly, this makes sure the default behavior of "save on SIGTERM" stays functional by default)
  && make -C ${src_dir} \
  && make -C ${src_dir} install \

# install redis-trib.rb redis-stat
  && mv ${src_dir}/src/redis-trib.rb /usr/bin/ \
  && chmod +x /usr/bin/redis-trib.rb \
  && gem install --version=3.3.3 redis \
  && gem install --version=0.4.14 redis-stat \

# redis-trib.rb 免交互
  && sed -i '/yes_or_die.msg/a\    return if ENV["QUIET_MODE"] == "1"' /usr/bin/redis-trib.rb \
  && rm -rf ${src_dir} \
  && yum history -y undo 1 \
  && yum clean all \
  && rm -rf /usr/share/man/* &> /dev/null

EXPOSE 6379
HEALTHCHECK --interval=10s --timeout=10s --retries=10 \
    CMD port_check 6379

ADD container-files /
#ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/entrypoint.sh"]
#CMD ["/usr/bin/supervisord"]