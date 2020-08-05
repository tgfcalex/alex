#!/usr/bin/env bash

set -e
# 定义nginx 日志路径
LOG_PATH="/var/lb/logs/"

# 定义nginx 访问日志文件名称
ACCESS_LOG="access.log"
ERROR_LOG="error.log"

for i in `find  $LOG_PATH -name "$ACCESS_LOG"`; do
    cd $(dirname $i)
    # 切割access日志
    if [[ -f $ACCESS_LOG ]]; then
        cp {,$(date +%F)-}${ACCESS_LOG}
        : > $ACCESS_LOG
    fi

    # 如果error日志>20m，切
    if [[ -f $ERROR_LOG ]]; then
        ERROR_SIZE=`ls -l $ERROR_LOG | awk '{ print $5 }'`
        if [[ $ERROR_SIZE -gt 20971520 ]]; then
            cp {,$(date +%F)-}${ERROR_LOG}
            : > ${ERROR_LOG}
        fi
    fi
done
# 查找nginx 日志目录下7天前的日志并删除
find ${LOG_PATH} -type f -name "*-${ACCESS_LOG}" -mtime +7 -delete
find ${LOG_PATH} -type f -name "*-${ERROR_LOG}"  -mtime +7 -delete
