FROM hub.dayu-boss.com/core/centos-jre8

ADD zookeeper-3.4.10.tar.gz /usr/local/
ADD container-files /

RUN set -x \
  \
  && ln -sv /usr/local/zookeeper-3.4.10 /usr/local/zookeeper \
  && chmod +x /usr/bin/{entrypoint,restart,start,status,stop}.sh /usr/local/zookeeper/bin/*.sh \
  \
  && mkdir -p /data/zookeeper/{log,data} \
  \
# clean
  && rm -f /usr/local/zookeeper/bin/*.cmd

ENV \
  ZOO_HOME=/usr/local/zookeeper \
  PATH=/usr/local/zookeeper/bin:$PATH \
  \
  ZOO_LOG_DIR=/data/zookeeper/log \
  ZOO_DATA_DIR=/data/zookeeper/data \
  ZOO_PORT=2181 \
  ZOO_TICK_TIME=4000 \
  ZOO_INIT_LIMIT=10 \
  ZOO_SYNC_LIMIT=4 \
  MYID=1

WORKDIR $ZOO_HOME

EXPOSE $ZOO_PORT 2888 3888
HEALTHCHECK --interval=10s --timeout=10s --retries=10 \
    CMD port_check ${ZOO_PORT}
