#!/usr/bin/env bash
# Description: APP增量回退脚本
# Date:2018.8.23


#加载环境变量文件
cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
source $cur_dir/../../../common/script/release/color-to-node.sh
source $cur_dir/_variable.sh

#说明
_usage_my() {
    echo -e "
        --------------------------------
            请检查参数是否正确
            Usage: $0  大鱼上传包路径
        ---------------------------------
    "
}

if [[ $# -ne 1 ]];then
    _usage_my
    exit 1
fi

# 定义上传路径
UPDATE_PATH="$1"

#定义增量包
cd $UPDATE_PATH
incrPKGS=`ls`

#通过备份还原
for APP in $incrPKGS;do
    if echo $RSPKG | grep -wo "$APP" &>/dev/null;then
        WORK_HOST="$RS"
    elif echo $ALLPKG | grep -wo "$APP" &>/dev/null;then
        WORK_HOST="$AS"
    elif echo $pay_impl_jars | grep -wo "$APP" &>/dev/null;then
        WORK_HOST="$AS"
    else
        continue
    fi

    for SERVER in $WORK_HOST;do
         pssh  -H  ${username}@${SERVER}:${port} "rsync -azq --delete ${bak_app_dir}/${APP}/  ${dist_app_dir}/${APP}/"
    done
done


