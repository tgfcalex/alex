#!/usr/bin/env bash

docker stop lb_api-ngx lb_hall-ngx lb_manager-ngx lb_mdcenter-ngx lb_mobile-ngx lb_rcenter-ngx
docker rm   lb_api-ngx lb_hall-ngx lb_manager-ngx lb_mdcenter-ngx lb_mobile-ngx lb_rcenter-ngx


# 通用参数
exp_ops='-tid --restart=always --net=lb_net '

#----------------- api 8001
docker run ${exp_ops} \
   --ip=10.60.110.1 \
   -p 8001:80 \
   --name=lb_api-ngx \
   --hostname=api-ngx \
   -v /var/lb/conf/api-ngx:/usr/local/openresty/nginx/conf \
   -v /var/lb/logs/api-ngx:/data/nginx/logs \
   hub:5000/openresty

# ----------------- hall 8002
docker run ${exp_ops} \
    --ip=10.60.120.1 \
    -p 8002:80 \
    --name=lb_hall-ngx \
    --hostname=hall-ngx \
    -v /var/lb/conf/hall-ngx:/usr/local/openresty/nginx/conf \
    -v /var/lb/logs/hall-ngx:/data/nginx/logs \
     hub:5000/openresty

# ----------------- manger 8003
docker run ${exp_ops} \
    --ip=10.60.130.1 \
    -p 8003:80 \
    --name=lb_manager-ngx \
    --hostname=manager-ngx \
    -v /var/lb/conf/manager-ngx:/usr/local/openresty/nginx/conf \
    -v /var/lb/logs/manager-ngx:/data/nginx/logs \
    hub:5000/openresty

# ----------------- mdcenter 8004
docker run ${exp_ops} \
    --ip=10.60.140.1 \
    -p 8004:80 \
    --name=lb_mdcenter-ngx \
    --hostname=mdcenter-ngx \
    -v /var/lb/conf/mdcenter-ngx:/usr/local/openresty/nginx/conf \
    -v /var/lb/logs/mdcenter-ngx:/data/nginx/logs \
    hub:5000/openresty   

# ----------------- mobile 8005
#docker run ${exp_ops} \
#    --ip=10.60.150.1 \
#    -p 8005:80 \
#    --name=lb_mobile-ngx \
#    --hostname=mobile-ngx \
#    -v /var/lb/conf/mobile-ngx:/usr/local/openresty/nginx/conf \
#    -v /var/lb/logs/mobile-ngx:/data/nginx/logs \
#    hub:5000/openresty

# ----------------- rcenter 8006
docker run ${exp_ops} \
    --ip=10.60.160.1 \
    -p 8006:80 \
    --name=lb_rcenter-ngx \
    --hostname=rcenter-ngx \
    -v /var/lb/conf/rcenter-ngx:/usr/local/openresty/nginx/conf \
    -v /var/lb/logs/rcenter-ngx:/data/nginx/logs \
    -v /var/lb/data/fserver/upload/data:/usr/local/nginx/html/fserver/files  \
    -v /var/lb/apps/rcenter:/usr/local/openresty/nginx/html/rcenter \
    -v /var/lb/apps/mobile-h5/:/usr/local/openresty/nginx/html/six/ \
    -v /var/lb/apps/pc-h5/:/usr/local/openresty/nginx/html/cp/ \
    -v /var/lb/script:/usr/local/openresty/nginx/script \
    hub:5000/openresty
