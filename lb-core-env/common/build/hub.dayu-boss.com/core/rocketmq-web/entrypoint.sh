#!/usr/bin/env bash

# Author: Tim
# Date  : 2018-05-26

export  JAVA_OPTS="
    $JAVA_OPT
    -Dcom.sun.management.jmxremote
    -Dcom.sun.management.jmxremote.port=12345
    -Dcom.sun.management.jmxremote.authenticate=false
    -Dcom.sun.management.jmxremote.ssl=false
    "

conf_file='/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/config.properties'

if [ -f "$conf_file" ]; then
    echo "
        rocketmq.namesrv.addr=${rocketmq_namesrv_addr:-127.0.0.1:9876}
        throwDone=true

    " > $conf_file
fi

exec "$@"
