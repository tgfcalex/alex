#!/usr/bin/env bash

#

buil_list="
    ./centos-base/build.sh

    ./centos-pg10.4/build.sh
    ./squid/build.sh

    ./centos-jre8/build.sh
    ./gb-gather-client/build.sh
    ./gb-gather-server/build.sh
    ./tomcat/build.sh
    ./tomcat-php/build.sh
    ./redis/build.sh
    ./rocketmq/build.sh
    ./zookeeper/build.sh

    ./centos-openresty-1.11.2.5/build.sh
    ./openresty/build.sh
    ./openresty-php72/build.sh
"

for i in $buil_list; do
    echo -------------------- $i
    if [[ -f "$i" ]]; then
        ( source $i )
    fi
done