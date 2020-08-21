#!/usr/bin/env bash
# -*- coding:utf-8 -*-

# Author: Tim
#
cur_dir_com="$( cd $(dirname ${BASH_SOURCE[0]}) && pwd )"
# 导入脚本所在目录下存在函数功能文件function.sh，
source $cur_dir/function.sh

# $1等于脚本执行后+的主机的参数 例如a6 赋值给host
host=$1
shift
work_host="${username}@${host}:${port}"

for app in $@;do
    (
        # 执行function中的函数，关闭dubbo服务和获取容器名字
        dubbo_off=$(get_dubbo_off $app)
        container=$(get_container_name $host $app)

        if [[ $docker_new == true ]] || [[ $project == "lb" ]] || [[ $project == "v-lb" ]]; then
            pssh_cmd="rectn ${container}  ${dubbo_off}"
        else
            pssh_cmd="docker exec ${container}  ${dubbo_off}"
        fi

        pssh_with_info

    ) &
    sleep 1
done
wait

