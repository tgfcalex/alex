FROM hub.dayu-boss.com/core/centos-jre8

ENV \
  PATH=/usr/local/rocketmq/bin:$PATH \
  brokerId=0 \
  brokerName=mq_1 \
  namesrvAddr=namesrv:9876

ADD alibaba-rocketmq.tar.gz /usr/local/rocketmq/
ADD container-files /
WORKDIR /usr/local/rocketmq/

RUN set -ex \
  \
  && mkdir -p ./conf/main/ \
  && chmod +x  ./bin/* /usr/bin/{restart,start,stop,entrypoint,status}.sh \
  \
  && mkdir -p /var/rocketmq/{store,logs/rocketmqlogs} \
  && ln -sv /var/rocketmq/store /root/store \
  && ln -sv /var/rocketmq/logs  /root/logs \
  \
  && rm -f ./bin/*.exe \
  && rm -rf /alibaba-rocketmq.tar.gz

VOLUME /var/rocketmq/store /var/rocketmq/logs
EXPOSE 9876 10911 10912

HEALTHCHECK --interval=10s --timeout=10s --retries=5 \
              CMD port_check 9876
