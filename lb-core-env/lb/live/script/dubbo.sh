#!/usr/bin/env bash

cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $cur_dir/_variable.sh

dubbo_version=`date "+%m%d%H"`

#将此dubbo_version的变量写入_variable.sh脚本中
echo $dubbo_version > /var/lb/dubbo_version/dubbo_version.txt
