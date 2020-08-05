FROM hub.dayu-boss.com/core/centos-base

RUN \
  set -ex \

# install supervisor
  && yum install -y squid \

# clean
  && yum clean all \
  && yum history new

ADD container-files /
WORKDIR /var/log/squid/

#ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/entrypoint.sh"]
#CMD ["/usr/bin/supervisord"]