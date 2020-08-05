#!/usr/bin/env bash
# __author__ == "Sun"
# date: 2018.7.18

#使用帮助
scriptUsage(){
    echo -e "
        应用全量脚本使用说明：
  -----------------------------------------------------------------------------------------------------------------------------------
        Usage: $0  {host_line}  {package1 package2 package3......}
            输入la3 时， r的静态资源全线推送
            输入lr1时，r 的静态资源全线推送

        Example:
            $0  {la1 | lr1}   fserver mobile-h5 pc-h5 hall manager
  ------------------------------------------------------------------------------------------------------------------------------------
    "
}

#脚本添加帮助信息
case $1 in
    -h|--help)
        scriptUsage
        ;;
esac

#加载环境变量脚本
cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
source $cur_dir/color-to-node.sh
source $cur_dir/_variable.sh
echo "cur_dir $cur_dir"

#定义命令执行结果输出
function command_with_info(){
    eval $command > /dev/null
    if [[ $? == "0" ]]; then
        echo -e "\033[32m     " $command "\033[0m"
    else
        echo -e "\033[31m     " $command "\033[0m"
    fi
}

host=$1
shift

#创建备份的目录/var/lb/apps/bak_apps/
for hosts in $AS $RS;do
    pssh -H  ${username}@${hosts} "ls /var/lb/apps/bak_apps"  &>/dev/null;
    if [  $? -ne 0 ];then
        echo -e "${hosts} 创建备份目录"
        pssh -H ${username}@${hosts} "mkdir -p /var/lb/apps/bak_apps"
    fi
done


for i in $@;do
#推送静态资源的包（增量)
    if echo $RSPKG | grep -wo $i &>/dev/null && [[ $i != "api"  ]] && [[ $i != "merchant-api" ]] && [[ $i != "distributor-api"  ]] && [[ `ls -A /var/env/apps/lb/work/$i` != "" ]];then
        if [[ $host == "la3" && $project == "lb" ]] || [[ $host == "lr1" && $project == "lb" ]];then
            echo -e "备份==> ${i}"
            command="rsync -azq --delete  ${distributed_dir}/${i}/ ${bak_app_dir}/$host/${i}/"
            command_with_info
            #添加一个以备份时间命名的文件
            /usr/bin/touch  ${bak_app_dir}/${host}/r/bakTime_$(date +%F-%H-%M-%S)
            echo -e "静态资源全线同步 ==> ${i}"
            command="rsync -azq --delete ${latest_app_dir}/$i/  ${distributed_dir}/$i/"
            command_with_info
        fi

#推送tomcat的包执行此命令
    elif echo $ALLPKG | grep -wo $i &>/dev/null  && [[ `ls -A /var/env/apps/lb/work/$i` != "" ]];then
        #备份远程主机的app包到控制机
        if [[ $host == "la1" || $host == "la2" || $host == "la3" ]];then
            echo -e "${host} 备份${i}"
            command="rsync -azq --delete ${username}@${host}:${dist_app_dir}/${i}/ ${bak_app_dir}/${host}/${i}/"
            echo "$command"
            command_with_info

            #添加一个以备份时间命名的文件
            touch ${bak_app_dir}/${host}/${i}/bakTime$(date +%F-%H-%M-%S)

            echo -e "${host} 同步${i}"
            command="/usr/bin/rsync -azq --delete  ${latest_app_dir}/${i}/ ${username}@${host}:${dist_app_dir}/${i}/"
            command_with_info
        else
            echo -e "${i}：==> 请确认指定的主机是否正确"
        fi
    else
        _error "${i} 目录为空，忽略同步"
    fi
done

# 新曾备份
echo "+++++++++++++++++++++++++++++++++"
sleep 2
source $cur_dir/backup.sh
