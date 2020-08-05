#!/usr/bin/env bash
# -*- coding:utf-8 -*-

# Author: Tim


# run 容器的时候，指定变量 redis_port replicas redis_all
# 执行脚本此脚本，即可

redis_port=${redis_port:-6379}

set -e
if [[ ! -z "$replicas" ]]; then
    replicas="--replicas $replicas"
fi

for i in  $redis_all; do
    redis_host=$(getent hosts $i | awk '{print $1}')
    redis_list="${redis_host}:${redis_port} ${redis_list}"
done
export QUIET_MODE=1
/usr/bin/redis-trib.rb create ${replicas} ${redis_list}
