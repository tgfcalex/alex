#!/usr/bin/env bash
# -*- coding:utf-8 -*-

# Author: Tim
# 获取线别 ${host: -1}
# -----------------------------------
cur_dir="$( cd $(dirname ${BASH_SOURCE[0]}) && pwd )"
# 导入脚本所在目录下存在函数功能文件function.sh，
source ${cur_dir}/function.sh
source ${cur_dir}/v_variable.sh

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
    if echo $RSPKG | grep -wo "${app}" &>/dev/null  && [[ `ls -A /var/env/apps/lb/work/${app}` != "" ]];then
        if [[ $host == "la1" ]] && [[ $project == "lb" ]];then
            echo -e "静态资源推送r1 r2 主机，：....推送${app}"
            command="ansible r -m synchronize -a 'src=/var/env/apps/lb/work/${app}/ dest=/var/v-lb/apps/${app}/ delete=yes'"
            command_with_info
        fi
    # 推送app包
    elif echo $ALLPKG | grep -wo "${app}" &>/dev/null  && [[ `ls -A /var/env/apps/lb/work/${app}` != "" ]];then
        echo -e "同步${app}"
        command="sudo /usr/bin/rsync -azq --delete  ${latest_app_dir}/${app}/ ${username}@$host:${v_dist_app_dir}/${app}/"
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

