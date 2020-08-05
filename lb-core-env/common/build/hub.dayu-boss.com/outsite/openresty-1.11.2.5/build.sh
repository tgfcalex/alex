#!/usr/bin/env bash

# Author: Tim
# Date  : 17-10-25
cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )


image_NAME='site-ngx'
clear
set -e
echo -e "\e[31m"
echo "======================================================================"
echo -e "\n\n 正在创建镜像 < $image_NAME >......\n请稍后......\n\n"
echo "======================================================================"
echo -e "\e[0m"
sleep 5

cd $cur_dir

find -name "*.sh" -exec chmod +x {} \;
chmod -R +x ./container-files/usr/bin/

docker build  -t $image_NAME .
#docker build --rm --no-cache -t $image_NAME .

sleep 3
echo -e "\e[31m"
echo "======================================================================"
echo -e "\n\n  < $image_NAME >创建完成...OK\n\n"
echo "======================================================================"
echo -e "\e[0m"

