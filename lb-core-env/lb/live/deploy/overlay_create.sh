#!/usr/bin/env bash


network_NAME='lbnet'

# --attachable 允许通过docker run的容器接入此overlay网络
docker network create \
    --attachable \
    -d overlay \
    --subnet=10.200.0.0/16 \
    ${network_NAME}
