#!/usr/bin/env bash

# by Tim

docker stop  mq_node1-m mq_node2-m mq_node3-m
docker rm    mq_node1-m mq_node2-m mq_node3-m

docker run -itd \
    -p 192.168.0.21:9876:9876 \
    --restart=always \
    --net=lb_net \
    --ip 10.60.210.1 \
    --hostname=mq_node1-m \
    --name mq_node1-m \
    -e brokerId=0 \
    -e brokerName=node1 \
    -e namesrvAddr="mq_node1-m:9876;mq_node2-m:9876;mq_node3-m:9876" \
    -v /var/lb/logs/rocketmq/node1-m:/var/rocketmq/logs/ \
    -v /var/lb/data/rocketmq/node1-m:/var/rocketmq/store/ \
    hub:5000/rocketmq

docker run -itd \
    -p 192.168.0.21:9877:9876 \
    --restart=always \
    --net=lb_net \
    --ip 10.60.210.2 \
    --hostname=mq_node2-m \
    --name mq_node2-m \
    -e brokerId=0 \
    -e brokerName=node2 \
    -e namesrvAddr="mq_node1-m:9876;mq_node2-m:9876;mq_node3-m:9876" \
    -v /var/lb/logs/rocketmq/node2-m:/var/rocketmq/logs/ \
    -v /var/lb/data/rocketmq/node2-m:/var/rocketmq/store/ \
    hub:5000/rocketmq

docker run -itd \
    -p 192.168.0.21:9878:9876 \
    --restart=always \
    --net=lb_net \
    --ip 10.60.210.3 \
    --hostname=mq_node3-m \
    --name mq_node3-m \
    -e brokerId=0 \
    -e brokerName=node3 \
    -e namesrvAddr="mq_node1-m:9876;mq_node2-m:9876;mq_node3-m:9876" \
    -v /var/lb/logs/rocketmq/node3-m:/var/rocketmq/logs/ \
    -v /var/lb/data/rocketmq/node3-m:/var/rocketmq/store/ \
    hub:5000/rocketmq


