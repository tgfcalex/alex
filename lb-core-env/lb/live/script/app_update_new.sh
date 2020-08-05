#!/usr/bin/env bash
# -*- coding:utf-8 -*-

# Author: Tim
# 获取线别 ${host: -1}
# -----------------------------------
cur_dir="$( cd $(dirname ${BASH_SOURCE[0]}) && pwd )"
# 导入脚本所在目录下存在函数功能文件function.sh，
source ${cur_dir}/function.sh
source ${cur_dir}/_variable.sh

# 需要更新的服务器为host
host=$1
shift

# 需要赋值 $command
function command_with_info(){
    eval $command > /dev/null
    if [[ $? == "0" ]]; then
        echo -e "\033[32m     " $command "\033[0m"
    else
        echo -e "\033[31m     " $command "\033[0m"
    fi
}

function app_update(){
    #创建备份的目录/var/lb/apps/bak_apps/
    for hosts in $AS $RS;do
        pssh -H  ${username}@${hosts} "ls /var/lb/apps/bak_apps"  &>/dev/null;
        if [  $? -ne 0 ];then
            echo -e "${hosts} 创建备份目录"
            pssh -H ${username}@${hosts} "mkdir -p /var/lb/apps/bak_apps"
        fi
    done
    unset command

    #推送静态资源的包（增量)
   # if echo $RSPKG | grep -wo "${app}$" &>/dev/null  && [[ `ls -A /var/env/apps/lb/work/${app}` != "" ]];then
    if echo $RSPKG | grep -wo "${app}" &>/dev/null  && [[ $app != "api" ]] && [[ $app != "merchant-api"  ]] && [[ $app != "distributor-api"  ]] && [[ `ls -A /var/env/apps/lb/work/${app}` != "" ]];then
        if [[ $host == "la3" ]] && [[ $project == "lb" ]];then
            echo -e "静态资源挂载分布式文件系统，推送到c主机，自动同步r ：....备份${app}"
            #command="rsync -azq --delete  ${distributed_dir}/${app}/ ${bak_app_dir}/r/${app}/"
            command="rsync -azq --delete  ${distributed_dir}/${app}/ ${bak_app_dir}/lr1/${app}/"
            command_with_info
            #添加一个以备份时间命名的文件
           # /usr/bin/touch  ${bak_app_dir}/r/${app}/bakTime_$(date +%F-%H-%M-%S)
            /usr/bin/touch  ${bak_app_dir}/lr1/${app}/bakTime_$(date +%F-%H-%M-%S)
            echo -e "静态资源挂载分布式文件系统，推送到c主机，自动同步r ：....推送${app}"
            command="rsync -avz --delete  /var/env/apps/lb/work/${app}/  ${distributed_dir}/${app}/"
            command_with_info
        fi

    # 推送app包
    elif echo $ALLPKG | grep -wo "${app}" &>/dev/null  && [[ `ls -A /var/env/apps/lb/work/${app}` != "" ]];then
        #在远端主机备份
        echo -e "${host} 备份${app}"
        command="rsync -azq --delete ${username}@${host}:${dist_app_dir}/${app}/ ${bak_app_dir}/${host}/${app}/"
        command_with_info
        #添加一个以备份时间命名的文件
        touch ${bak_app_dir}/${host}/${app}/bakTime$(date +%F-%H-%M-%S)
        echo -e "${host}同步${app}"
        command="sudo /usr/bin/rsync -azq --delete  ${latest_app_dir}/${app}/ ${username}@$host:${dist_app_dir}/${app}/"
        command_with_info
    else
        _error "${app} 目录为空，忽略同步"
    fi
}

for app in $@;do
        if [[ ! -z $app ]]; then
            app_update
        fi
            sleep 1
done
wait

