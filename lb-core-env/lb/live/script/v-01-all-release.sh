#!/usr/bin/env bash
# changeDate: 18-06-18 ==> By Sun

cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
source $cur_dir/color-to-node.sh
source $cur_dir/v_variable.sh


# 使用帮助
    if [ $# -ne 1 ] || [[ $1 == "--help" ]];then
        echo  -e "
        生成测试线发包，只有一条线路 la1，nginx是lr1 lr2
            Usage: $0        la1
        ---------------------------------------------------------------
            la1 ==> 推送tomcat的包,当输入la1时，所有静态资源包全线推送{lr1,lr2}
        ---------------------------------------------------------------
            需要定义ansible，r组中的主机有哪些"
        exit 1
    fi

function command_with_info(){
    eval $command > /dev/null
    if [[ $? == "0" ]]; then
        echo -e "\033[32m     " $command "\033[0m"
    else
        echo -e "\033[31m     " $command "\033[0m"
    fi
}

# 键入回车确认等待
_enter_go_on(){
    _h2 "     "
    read -p "        请按回车继续..." var
}

_enter_ok_go_on(){
unset ok
while [[ ! "$ok" == "ok" ]]; do
    read -p "请输入'ok' ,按回车继续：" ok
done
}

# ------------------ 全线发包脚本，此处定义全app应用 -------------------------

line=$1

ITEM=1

# ------------------------------------------------ 步骤一： 反注册dubbo ------------------------------------------------
_h2 "[ Step ${ITEM} ]: 反注册 APP 的 dubbo 服务..."; let ITEM+=1
_enter_ok_go_on
source $cur_dir/service_stop_new.sh $line $options_all

# ------------------------------------------------ 步骤二： 停止tomcat ------------------------------------------------
_h2 "[ Step ${ITEM} ]: 停止tomcat...注意！务必确认服务关闭；health check页面显示应用状态：down。 "; let ITEM+=1

_enter_ok_go_on
source $cur_dir/tomcat_stop_new.sh $line $options_all


# ------------------------------------------------ 步骤三： 推送更新包 ------------------------------------------------
# -------- rcenter 特殊处理,推送la3线，静态资源推送全线 --------
if [[ $line == la1 && $project == "lb" ]];then
    _h2 "[ Step ${ITEM}.${ITEM_EX} ]: 推送静态资源到 lr1 lr2"; let ITEM_EX+=1
    _enter_go_on
    source $cur_dir/v-app_update_new.sh $line  $RSPKG
fi


# -------- tomcat应用包--------
_h2 "[ Step ${ITEM}.${ITEM_EX} ]: 推送&解压 ==> 全线tomcat包"; let ITEM+=1
_enter_go_on
source $cur_dir/app_update_new.sh  $line $options_all

# ------------------------------------------------ 步骤四： 启动tomcat ------------------------------------------------
# -------- 服务先启动 --------
_h2 "[ Step ${ITEM} ]: 开启tomcat.服务.. $line $options_service"; let ITEM+=1
_enter_ok_go_on
source $cur_dir/tomcat_start_new.sh $line $options_service


# -------- 应用后启动 --------
_h2 "[ Step ${ITEM} ]: 开启tomcat.应用.. $line $options_apply"; let ITEM+=1
_enter_ok_go_on
source $cur_dir/tomcat_start_new.sh $line $options_apply

