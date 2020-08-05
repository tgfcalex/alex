#!/usr/bin/env bash
# __author__ == "Sun"
# date: 2018.7.18

#使用帮助
scriptUsage(){
    echo -e "
        应用增量脚本使用说明：
  -----------------------------------------------------------------------------------------------------------------------------------
        Usage: $0  {host_line}  {package1 package2 package3......}
            输入la1 时， r的静态资源全线推送
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
source $cur_dir/v_variable.sh

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

for i in $@;do
#推送静态资源的包（增量)
    if echo $RSPKG | grep -wo "$i" &>/dev/null  && [[ `ls -A /var/env/apps/lb/work/$i` != "" ]];then
        if [[ $host == "la1" && $project == "v-lb" ]] || [[ $host == "lr1" && $project == "v-lb" ]];then
            if [[ $i == "rcenter" ]];then
                echo -e "静态资源全线同步 ==> ${i}"
                command="ansible  r  -m synchronize -a 'src=${latest_app_dir}/work/$i/ dest=${v_dist_app_dir}/$i/${dubbo_version}/$i/'"
                command_with_info
            else
                echo -e "静态资源全线同步 ==> ${i}"
                command="ansible  r  -m synchronize -a 'src=${latest_app_dir}/work/$i/ dest=${v_dist_app_dir}/$i/'"
                command_with_info
            fi
        fi

#推送tomcat的包执行此命令
    elif echo $ALLPKG | grep -wo "$i" &>/dev/null  && [[ `ls -A /var/env/apps/lb/work/$i` != "" ]];then
        #备份远程主机的app包到控制机
        if [[ $host == "la1" ]];then
            echo -e "${host}同步${i}"
            command="sudo /usr/bin/rsync -azq   ${latest_app_dir}/${i}/ ${username}@${host}:${v_dist_app_dir}/${i}/"
            command_with_info
        else
            echo -e "请确认${i}包，指定的主机是否正确"
        fi
    else
        _error "${i} 目录为空，忽略同步"
    fi
done
