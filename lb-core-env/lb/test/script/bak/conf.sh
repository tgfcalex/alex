#!/usr/bin/env bash

# ,分隔
# redis 集群一
# REDIS_INFO='rd_n01-rd:6379,rd_n02-rd:6379,rd_n03-rd:6379'
REDIS_INFO='rd_n01-rd'
# ,分隔
ZOO_INFO='zk_node1:2181'
# ；分隔  注意！！！
MQ_INFO="mq_node1-m:9876;mq_node2-m:9876;mq_node3-m:9876"

FSERVER='http://fserver-ngx:80'

# gather_zookeeper_node_nginx="gather-ngx:71 gather-ngx:72"
#cd /var/lb/apps/
cd /var/env/apps/work/


# _re_comand <file_name>    <key_word>    <var_word>
_re_comand(){
    for i in `find -type f -name   $1`  ; do
        sed -i "/^${2}/s|^.*$|${2}${3}|" $i
    done
}

# dubbo-conf.properties

# -------------------- redis
# redis-conf.properties
_re_comand redis-conf.properties  "data.redis.host=" "$REDIS_INFO"
_re_comand redis-conf.properties  "pageCache.redis.host=" "$REDIS_INFO"
_re_comand redis-conf.properties  "shiro.session.host=" "$REDIS_INFO"
_re_comand redis-conf.properties  "shiro.auth.host=" "$REDIS_INFO"
_re_comand redis-conf.properties  "api.token.host=" "$REDIS_INFO"
_re_comand redis-conf.properties  "gather.redis.host=" "$REDIS_INFO"
_re_comand redis-conf.properties  "redis.host=" "$REDIS_INFO"

# 
_re_comand redis-conf.properties  "data.redis.hosts=" " "
_re_comand redis-conf.properties  "pageCache.redis.hosts=" " "
_re_comand redis-conf.properties  "shiro.session.hosts=" " "
_re_comand redis-conf.properties  "shiro.auth.hosts=" " "
_re_comand redis-conf.properties  "api.token.hosts=" " "
_re_comand redis-conf.properties  "gather.redis.hosts=" " "

# -------------------- rockermq
# service-conf.properties
_re_comand service-conf.properties  "rocketMQ.namesrvAddr=" "$MQ_INFO"

# -------------------- pgsql
# db-conf.properties
_re_comand db-conf.properties "bossDataSource.url=" "jdbc:postgresql://192.168.0.21:5504/lb-boss?characterEncoding=UTF-8"

# -------------------- zookeeper
# schedule-conf.properties
_re_comand schedule-conf.properties  "schedule.zookeeper.url=" "$ZOO_INFO"

# server-conf.properties
_re_comand server-conf.properties  "server.zookeeper.url=" "$ZOO_INFO"

