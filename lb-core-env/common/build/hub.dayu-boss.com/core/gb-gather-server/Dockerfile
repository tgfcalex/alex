FROM hub.dayu-boss.com/core/centos-jre8

WORKDIR /usr/local/gather-server/bin/
#ENV PATH /usr/local/gather-server/bin/:$PATH


ADD container-files /
RUN \
  set -ex \
  \
  && chmod +x /usr/bin/{restart,start,stop}.sh

HEALTHCHECK \
    --interval=10s --timeout=8s --retries=3 \
    CMD port_check 9000
