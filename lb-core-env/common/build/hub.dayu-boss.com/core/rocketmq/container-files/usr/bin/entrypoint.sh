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


cat <<'EOF'>> /etc/profile
export  JAVA_OPTS="
    $JAVA_OPT
    -Dcom.sun.management.jmxremote
    -Dcom.sun.management.jmxremote.port=12345
    -Dcom.sun.management.jmxremote.authenticate=false
    -Dcom.sun.management.jmxremote.ssl=false
    "
EOF

# -------------------------
MQ_CONF=/usr/local/rocketmq/conf/main/mqbroker.conf

if [ ! -f $MQ_CONF ];then
    if [ ${brokerId} -eq 0 ] ; then
        echo 'brokerRole=SYNC_MASTER' > $MQ_CONF
    else
        echo 'brokerRole=SLAVE' > $MQ_CONF
    fi
    cat <<EOF >> $MQ_CONF

brokerId=${brokerId}
brokerName=${brokerName}
namesrvAddr=${namesrvAddr}

brokerClusterName=DefaultCluster
deleteWhen=04
fileReservedTime=48
flushDiskType=SYNC_FLUSH
autoCreateTopicEnable=true
autoCreateSubscriptionGroup=true
maxMessageSize=524288000
listenPort=10911
haListenPort=10912
brokerIP1=$(hostname -i)
EOF

else
    sed -i "/brokerIP1=/s|^.*$|brokerIP1=$(hostname -i)|" ${MQ_CONF}
fi

exec "$@"
