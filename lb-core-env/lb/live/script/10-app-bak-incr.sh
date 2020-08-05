#!/usr/bin/env bash
#Description: 大鱼调用->增量发包脚本
#Date: 2018.8.21

#加载环境变量文件
cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
source $cur_dir/../../../common/script/release/color-to-node.sh
source $cur_dir/_variable.sh


#说明
_usage_my() {
    _error "请检查参数"
    echo -e "
                Usage:  $0  "大鱼上传包路径"
            "

}

#无参数，退出
if [[ $# -ne 1 ]];then
    _usage_my
    exit 1
fi

#命令输出
function command_with_info(){
    eval $command > /dev/null
    if [[ $? == "0" ]]; then
        echo -e "\033[32m     " $command "\033[0m"
    else
        echo -e "\033[31m     " $command "\033[0m"
    fi
}

# 定义上传路径
UPDATE_PATH="$1"
UP_FILE_LIST="$1/../up_file_list"

#判断目录不存在，退出
if [[ ! -d  ${UPDATE_PATH} && "$(basename ${UPDATE_PATH})" == "updatefile" ]];then
    _usage_my "$1: 目录不存在，退出"
    exit 2
fi

#创建备份的目录/var/lb/apps/bak_apps/
for hosts in $AS $RS;do
    pssh -H  ${username}@${hosts} "ls /var/lb/apps/bak_apps"  &>/dev/null;
    if [  $? -ne 0 ];then
        echo -e "${hosts} 创建备份目录"
        pssh -H ${username}@${hosts} "mkdir -p /var/lb/apps/bak_apps"
    fi
done

_h2 "更新目录 ${UPDATE_PATH}" "备份目录: ${bak_app_dir}"
cd $UPDATE_PATH

# 解压war和zip包
if ls *.war &> /dev/null; then
    pkg_war=`ls *.war`
fi
if ls *.zip &> /dev/null; then
    pkg_zip=`ls *.zip`
fi

#解压上传目录下的所有zip和war包，并将增量文件记录UP_FILE_LIST文件中
if [[ ! -z $pkg_zip ]] || [[ ! -z $pkg_war ]]; then
    for pkg in $pkg_zip  $pkg_war; do
        rm -rf ${pkg%.*}
        unzip -l $pkg
        unzip -o $pkg
        rm -f $pkg
        # 推送前，将更新的文件名记录，保存到 ${UP_FILE_LIST}
        echo -e "\033[31m-----${pkg%.*}---$(date +%F-%H:%M:%S)--\033[0m"  >> ${UP_FILE_LIST}
        find ${pkg%.*} -type f >> ${UP_FILE_LIST}
    done
else
    _error "Error : 找不到 *.war *.zip"
    exit 2
fi

# 判断解压后的目录
for i in `ls $UPDATE_PATH`;do
    if ! echo "${ALLPKG} ${RSPKG} pay-impl-jars" | grep -wq $i &>/dev/null;then
        _error "$i : 未知的app更新，请确定${UPDATE_PATH}下的目录属于:"   "${ALLPKG} ${RSPKG}"
        exit 3
    fi
done

# 遍历更新的 App
for APP in `ls ${UPDATE_PATH}`;do
    # 根据 App 获取更新的主机- 多加elif判断，防止有其他zip包存在，误传
    if echo $RSPKG | grep -wo "$APP" &>/dev/null ;then
        WORK_HOST="$RS"
    elif echo $ALLPKG | grep -wo "$APP" &>/dev/null;then
        WORK_HOST="$AS"
    elif echo $pay_impl_jars | grep -wo "$APP" &>/dev/null;then
        WORK_HOST="$AS"
    else
        continue
    fi
    _info "增量更新包目录 ==> $APP"
    _info "备份的host ==> $WORK_HOST"

    # 遍历更新的主机
    for SERVER in `echo $WORK_HOST`;do
        _bold '----' "   ===> ${SERVER}"
        # 遍历文件进行备份
        _info '---- 备份程序' "$APP ---"
        command="pssh  -H  ${username}@${SERVER}:${port} 'rsync -azq --delete  ${dist_app_dir}/${APP}/  ${bak_app_dir}/${APP}/'"
        command_with_info
        _info '---- 推送更新中 ---'
        if [[ $APP == "rcenter" ]];then
            command="sudo  /usr/bin/rsync -azq  ${UPDATE_PATH}/${APP}/ ${username}@${SERVER}:${dist_app_dir}/${APP}/${dubbo_version}/${APP}/"
            command_with_info
        else
            command="sudo /usr/bin/rsync -azq   ${UPDATE_PATH}/${APP}/ ${username}@${SERVER}:${dist_app_dir}/${APP}/"
            command_with_info
        fi
    done
done
