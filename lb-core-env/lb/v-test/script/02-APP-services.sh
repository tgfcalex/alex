#!/usr/bin/env bash

cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
source $cur_dir/../../../common/script/v-release/color-to-node.sh
source $cur_dir/_variable.sh

# 使用帮助
# 使用帮助
    if [[ $1 == "--help" ]] || [[ $1 == "-h" ]];then
        echo  -e "
            Usage: $0        la{1..3}  {container_service}
        ---------------------------------------------------------------
            Example:
                $0  la1  'tomcat服务，支持多个服务'
        ---------------------------------------------------------------"
        exit 1
    fi

# 键入回车确认等待
_enter_go_on(){
    _h2 "-----------------------------------------"
    read -p "        请按回车继续..." var
    _h2 "-----------------------------------------"
}

_enter_ok_go_on(){
unset ok
while [[ ! "$ok" == "ok" ]]; do
    read -p "请输入'ok' ,按回车继续：" ok
done
}


ITEM=1
# ============= 反注册dubbo，tomcat stop &&  start ===============
_h2 "[ Step ${ITEM} ]: 反注册 APP 的 dubbo 服务..."; let ITEM+=1
_enter_ok_go_on
source $cur_dir/../../../common/script/v-release/service_stop_new.sh $@


_h2 "[ Step ${ITEM} ]: 停止tomcat... "; let ITEM+=1

_enter_ok_go_on
source $cur_dir/tomcat_stop_new.sh $@


_h2 "[ Step ${ITEM} ]: 开启tomcat...  $@"; let ITEM+=1
_enter_go_on
source $cur_dir/tomcat_start_new.sh $@
