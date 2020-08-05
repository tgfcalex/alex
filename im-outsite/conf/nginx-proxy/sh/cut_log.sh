http_logs_path="/usr/local/openresty/nginx/logs"                                                             
tcp_logs_path="/var/log/nginx/"
http_logs_access="access"                                                                            

#!/usr/bin/env bash

set -e
# 定义nginx 日志路径
HTTP_LOG_PATH="/data/nginx/logs"
TCP_LOG_PATH="/var/log/nginx"

# 定义nginx 访问日志文件名称
HTTP_ACCESS_LOG="access.log"
TCP_ACCESS_LOG="tcp-access.log"
ERROR_LOG="error.log"


# 切割http_access.log
if [[ -f $HTTP_LOG_PATH/$HTTP_ACCESS_LOG ]]; then
    cp $HTTP_LOG_PATH/{,$(date +%F)-}${HTTP_ACCESS_LOG}
    : > $HTTP_LOG_PATH/$HTTP_ACCESS_LOG
fi
# 切割tcp_access.log
if [[ -f $TCP_LOG_PATH/$TCP_ACCESS_LOG ]]; then
    cp $TCP_LOG_PATH/{,$(date +%F)-}${TCP_ACCESS_LOG}
    : > $TCP_LOG_PATH/$TCP_ACCESS_LOG
fi

# 判断大小切割error.log （ > 20m ）
if [[ -f $HTTP_LOG_PATH/$ERROR_LOG ]]; then
    ERROR_SIZE=`ls -l  $HTTP_LOG_PATH/$ERROR_LOG | awk '{ print $5 }'`
    if [[ $ERROR_SIZE -gt 20971520 ]]; then
        cp  $HTTP_LOG_PATH/{,$(date +%F)-}${ERROR_LOG}
        : >  $HTTP_LOG_PATH/${ERROR_LOG}
    fi
fi

# 查找nginx 日志目录下10天前的日志并删除
find ${HTTP_LOG_PATH} -type f -name "*-${HTTP_ACCESS_LOG}" -mtime +10 -delete
find ${HTTP_LOG_PATH} -type f -name "*-${HTTP_ERROR_LOG}"  -mtime +10 -delete
find ${TCP_LOG_PATH} -type f -name "*-${TCP_ERROR_LOG}"  -mtime +10 -delete
