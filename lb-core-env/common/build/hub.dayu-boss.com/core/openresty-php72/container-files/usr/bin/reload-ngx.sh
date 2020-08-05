#!/usr/bin/env bash

# Author: Tim
# Date  : 17-11-08
# 判断 nginx -s reload 命令的返回值 $reload_status，
# 输出 reload 时间和结果 到 /data/nginx/logs/reload.log


reload_info () {
    echo -n $(TZ=Asia/Shanghai date +%F" "%X"  CST")
    nginx -s reload &> /dev/null
    if [[ "$?" == 0 ]]; then
        echo "    OK"
    else
        echo "    ERR"
    fi
}

# main
echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
reload_info | tee -a /data/nginx/logs/reload.log
