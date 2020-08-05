#!/usr/bin/env bash

# 创建各ngx的日志目录(宿主机)
log_dir='/var/lb/logs/core-ngx/'
ngx_list='
    api
    hall
    manager
    mdcenter
    rcenter
    mobile-h5
    pc-h5
'
for i in $ngx_list; do
    if [[ ! -d ${log_dir}$i ]]; then
        mkdir -p ${log_dir}$i
    fi
done

# 创建各ngx的root(宿主机)
root_dir='/var/lb/apps/core-ngx/'
ngx_root='
    fserver
    rcenter
    mobile-h5
    pc-h5
'
for i in $ngx_root; do
    if [[ ! -d ${root_dir}$i ]]; then
        mkdir -p ${root_dir}$i
    fi
done

ln -sv /var/lb/apps/core-ngx/mobile-h5  /var/lb/apps/
ln -sv /var/lb/apps/core-ngx/pc-h5      /var/lb/apps/
ln -sv /var/lb/apps/core-ngx/rcenter    /var/lb/apps/

# 通用参数
exp_ops='-tid --restart=always --net=lb_net '

# 删除旧容器
docker stop lb_core-ngx
docker rm   lb_core-ngx
# ----------------------------------------------
docker run ${exp_ops} \
    --ip=10.60.110.9 \
    -p 8001:8001 \
    -p 8002:8002 \
    -p 8003:8003 \
    -p 8004:8004 \
    -p 8005:8005 \
    -p 8006:8006 \
    -p 8007:8007 \
    -p 8008:8008 \
    --name=lb_core-ngx \
    --hostname=core-ngx \
    -v /var/lb/conf/core-ngx/:/usr/local/openresty/nginx/conf/ \
    -v /var/lb/logs/core-ngx/:/data/nginx/logs/ \
    -v /var/lb/script:/usr/local/openresty/nginx/script \
    -v /var/lb/apps/core-ngx/rcenter:/usr/local/openresty/nginx/html/rcenter \
    -v /var/lb/apps/core-ngx/mobile-h5/:/usr/local/openresty/nginx/html/six/ \
    -v /var/lb/apps/core-ngx/pc-h5/:/usr/local/openresty/nginx/html/pc/ \
    -v /var/lb/data/fserver/upload/data:/usr/local/openresty/nginx/html/fserver/files  \
    hub:5000/openresty
