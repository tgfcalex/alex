#!/usr/bin/env bash

# by Tim

docker stop  zk_node1
docker rm    zk_node1


docker run -itd \
    -p 192.168.0.20:2181:2181 \
    --restart=always \
    --net=lb_net \
    --ip 10.60.200.1 \
    --hostname=zk_node1 \
    --name zk_node1 \
    -e MYID=1 \
    -e ZOO_SERVERS=server.1=zk_node1:2888:3888 \
    -v /var/lb/data/zookeeper/node1:/data/zookeeper/data \
    -v /var/lb/logs/zookeeper/node1:/data/zookeeper/log \
    hub:5000/zookeeper

