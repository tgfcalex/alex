#!/usr/bin/env bash

# Author: Tim
# Date  : 17-10-25

set -ex

# 注意！！！
# 程序配置文件设置在 /etc/*.conf
# docker run 的时候，需要 -e指定 mount_conf_dir；把里面的 *.conf 链接到 /etc
#for i in supervisord.conf lsyncd.conf zabbix_agentd.conf redis.conf; do
#    if [[ -f ${mount_conf_dir}$i ]]; then
#        ln -svf ${mount_conf_dir}$i /etc/$i
#    fi
#done

# 防止重启后这些文件因内容未更改，而不去写redis
#echo   > /var/data/rcenter_white_list
#echo   > /var/data/site_domains
#echo   > /var/data/site_black_white_ip_list
#echo   > /var/data/site_info
#
#echo   > /var/data/ftl_white_list

#echo   > /var/data/pb_rcenter_white_list
#echo   > /var/data/pb_site_black_white_ip_list
#echo   > /var/data/pb_site_domains
#echo   > /var/data/pb_site_info

echo "
platform=$platform
stype=$stype
" > /etc/environment

# 防止 stop -> start 后ip_db.txt仍存在，而不去写redis
if [[ -f /var/data/ip_db.txt ]]; then
    rm -f /var/data/ip_db.txt
fi

if [[ ! -d /usr/local/openresty/nginx/script/sh/is_flush/ ]]; then
    mkdir -p /usr/local/openresty/nginx/script/sh/is_flush/
fi

if [[ ! -d /var/logs/nginx/tcmalloc/ ]]; then
    mkdir -p /var/logs/nginx/tcmalloc/
fi
if [[ ! -d /var/data/nginx/tmps/nginx_client/ ]]; then
    mkdir -p /var/data/nginx/tmps/nginx_client/
fi
if [[ ! -d /var/data/nginx/tmps/nginx_proxy/ ]]; then
    mkdir -p /var/data/nginx/tmps/nginx_proxy/
fi
if [[ ! -d /var/data/nginx/tmps/nginx_fastcgi/ ]]; then
    mkdir -p /var/data/nginx/tmps/nginx_fastcgi/
fi


# 修改lsync配置监控目录具体到$platform ---- by Tim 2018/03/16
sed -i /\$platform/s/\$platform/$platform/ /etc/lsyncd.conf

# 先启动redis， init.py才能顺利执行

#echo "启动站点redis"
#/usr/bin/redis-server /etc/redis.conf && echo redis OK
#wait

#if [[ -f  /usr/local/openresty/nginx/script/py/init.py ]]; then
#    echo -e "----------\n  init.py\n----------"
#    python /usr/local/openresty/nginx/script/py/init.py  >> /var/log/fetch_data.log  && echo init OK
#fi

# 做链接,替换系统配置:
if [[ -f /usr/local/openresty/nginx/conf/nginx/crontab ]]; then
    cat /usr/local/openresty/nginx/conf/nginx/crontab | tee /etc/crontab
fi

#添加入口操作，取消redis的警告  -By Sun
#WARNING-1: TCP backlog设置值
sysctl -w net.core.somaxconn=32768
#WARNING-2: vercommit_memory 内存不足情况下，save失败
sysctl -w vm.overcommit_memory=1
#透明大页，导致redis延迟和内存使用问题
echo never > /sys/kernel/mm/transparent_hugepage/enabled

exec "$@"
