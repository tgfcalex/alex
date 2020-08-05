#!/usr/bin/env bash

# 将上次执行 _command 的时间写入 $TIME_FILE 文件，赋值 LAST_TIME
# 每次判断NOW与LAST_TIME 的时间间隔，间隔太小就不会再次执行 _command

TIME_FILE="/var/data/check.file"
CHECK_TIME=180

# 执行reload，并记录本次reload时间到/var/data/check.file，
# set -e ==> reload 失败不记录
_command (){
    set -e
    reload-ngx
    date +%s > $TIME_FILE
}

if [[ ! -f "$TIME_FILE" ]]; then
    date +%s > $TIME_FILE
fi

LAST_TIME=`cat $TIME_FILE`
NOW=`date +%s`

#
if [[ $((${NOW} - ${LAST_TIME})) -gt "$CHECK_TIME" ]]; then
    _command
else
    true
fi
