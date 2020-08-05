#!/usr/bin/env bash

# by Tim

docker stop  rd_n01-rd rd_n02-rd rd_n03-rd
docker rm    rd_n01-rd rd_n02-rd rd_n03-rd


docker run -itd \
    -p 192.168.0.21:6379:6379 \
    --restart=always \
    --net=lb_net \
    --ip 10.60.220.1 \
    --hostname=rd_n01-rd \
    --name rd_n01-rd \
    hub:5000/redis

#docker run -itd \
#    -p 192.168.0.21:6380:6379 \
#    --restart=always \
#    --net=lb_net \
#    --ip 10.60.220.2 \
#    --hostname=rd_n02-rd \
#    --name rd_n02-rd \
#    hub:5000/redis
#
#docker run -itd \
#    -p 192.168.0.21:6381:6379 \
#    --restart=always \
#    --net=lb_net \
#    --ip 10.60.220.3 \
#    --hostname=rd_n03-rd \
#    --name rd_n03-rd \
#    hub:5000/redis
#
