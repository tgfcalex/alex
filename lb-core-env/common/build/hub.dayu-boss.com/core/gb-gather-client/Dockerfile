FROM hub.dayu-boss.com/core/centos-jre8

WORKDIR /usr/local/gather-client/bin

ADD container-files /
RUN \
  set -ex \
  \
  && chmod +x /usr/bin/{restart,start,stop}.sh


