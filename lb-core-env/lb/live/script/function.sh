#!/usr/bin/env bash

#
# Author: Tim
#
# 通用函数

# --------------------------------------------
# 通过 host 和app 获取容器名
# 接受2个参数
function get_container_name(){
    #$1=a6
    host_name=$1
    app_name=$2
    # 执行脚本传入的参数定义为哪个线，如la6 ， line_number获取字符串中的数字，判断哪个线，拿到容器名
    line_number=`echo $host_name | tr -cd [0-9]`
    project=${project}

    if [[ $project == "lb" ]]; then
       return_str="${project}_${app_name}-${line_number}"
    elif [[ $project == "v-lb" ]];then
        return_str="v_${app_name}-${line_number}"
    fi

    echo $return_str
}

# --------------------------------------------
# 通过 app 获取关闭 dubbo 的命令
function get_dubbo_off(){
    app_name=$1
    case $app_name in
        mobile)
            ex_uri="/"
        ;;
        lottery-mobile)
            ex_uri=lottery
        ;;
        *)
            ex_uri=$1
        esac
    return_str="curl -s http://localhost:8080/${ex_uri}/destroy/serviceStop | grep success"
    echo $return_str
}

# --------------------------------------------
#
function pssh_with_info(){

    eval pssh -H $work_host -t 1000 -i   '${pssh_cmd}' > /dev/null
    if [[ $? == "0" ]]; then
        echo -e "\033[32m     " pssh -H $work_host -t 1000 -i \'${pssh_cmd}\' "\033[0m"
    else
        echo -e "\033[31m     " pssh -H $work_host -t 1000 -i \'${pssh_cmd}\' "\033[0m"
    fi
}
# --------------------------------------------
