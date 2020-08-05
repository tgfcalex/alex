#!/usr/bin/env bash


network_NAME='lb_net'

# --attachable 允许通过docker run的容器接入此overlay网络
docker network create \
    --attachable \
    -d bridge \
    --subnet=10.60.0.0/16 \
    ${network_NAME}

