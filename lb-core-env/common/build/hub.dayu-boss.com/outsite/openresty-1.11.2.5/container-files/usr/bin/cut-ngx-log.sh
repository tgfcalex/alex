#!/usr/bin/env bash

set -e
# 定义nginx 日志路径
LOG_PATH="/var/logs/nginx/"

# 定义nginx 访问日志文件名称
ACCESS_LOG="access.log"
ERROR_LOG="error.log"

cd ${LOG_PATH}

# 切割access.log
if [[ -f $ACCESS_LOG ]]; then
    cp {,$(date +%F)-}${ACCESS_LOG}
    : > $ACCESS_LOG
fi

# 判断大小切割error.log （ > 20m ）
if [[ -f $ERROR_LOG ]]; then
    ERROR_SIZE=`ls -l $ERROR_LOG | awk '{ print $5 }'`
    if [[ $ERROR_SIZE -gt 20971520 ]]; then
        cp {,$(date +%F)-}${ERROR_LOG}
        : > ${ERROR_LOG}
    fi
fi

# 查找nginx 日志目录下10天前的日志并删除
find ${LOG_PATH} -type f -name "*-${ACCESS_LOG}" -mtime +10 -delete
find ${LOG_PATH} -type f -name "*-${ERROR_LOG}"  -mtime +10 -delete
