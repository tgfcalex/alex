#!/usr/bin/env bash

# Author: Tim

function build_cmd(){

    set -e
    cd $cur_dir
    if [[ -d ./container-files/usr/bin/ ]]; then
        chmod -R +x ./container-files/usr/bin/
    fi

    echo -e "\e[31m
    ======================================================================
    正在创建镜像 < $image_NAME >...
        请稍后...
    ======================================================================
    \e[0m"
    sleep 5

    sudo docker build --rm -t $image_NAME .
    sudo docker push  $image_NAME

    echo -e "\e[31m
    ======================================================================
      < $image_NAME >创建完成...OK
    ======================================================================
    \e[0m"
    sleep 5

}