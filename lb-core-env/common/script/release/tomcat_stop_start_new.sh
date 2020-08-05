#!/usr/bin/env bash
# -*- coding:utf-8 -*-

# Author: Tim
#
cur_dir_com="$( cd $(dirname ${BASH_SOURCE[0]}) && pwd )"
# 导入脚本所在目录下存在函数功能文件function.sh，
source ${cur_dir_com}/function.sh

# 判断脚本是
case $1 in
    stop|close|c)
        commad="stop.sh"
        shift
        ;;
    start|open|o)
        commad="start.sh"
        shift
        ;;
    *)
        echo Userage：  $0  ' <o|c>  <HOST>  <APP> [APP2]..'
        exit 1
        ;;
esac

# error  sun think $1 = stop  应该改为$2
host=$1
shift
work_host="${username}@${host}:${port}"

#
for app in $@;do
    (
        container=$(get_container_name $host $app)
        if [[ $docker_new == true ]] || [[ $project == "lb" ]] || [[ $project == "v-lb" ]];then
            pssh_cmd="rectn ${container} ${commad}"
        else
            pssh_cmd="docker exec ${container} ${commad}"
        fi

        pssh_with_info
    ) &
    sleep 1
done
wait

sleep 3
echo "
     查看容器 tomcat 进程 < Bootstrap > 状态：
"
for app in $@;do
    container=$(get_container_name $host $app)
    echo --------------- $container ---------------
    if [[ $docker_new == true ]] || [[ $project == "lb" ]] || [[ $project == "v-lb" ]]; then
        pssh -H $work_host -i "rectn ${container} jps"
    else
        pssh -H $work_host -i "docker exec ${container} jps"
    fi
done
wait


