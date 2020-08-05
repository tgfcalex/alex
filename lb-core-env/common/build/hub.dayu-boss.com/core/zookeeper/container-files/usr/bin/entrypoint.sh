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

# Generate the config only if it doesn't exist
CONFIG="/usr/local/zookeeper/conf/zoo.cfg"
if [ ! -f "$CONFIG" ]; then

    echo "autopurge.snapRetainCount=100" >> "$CONFIG"
    echo "autopurge.purgeInterval=3" >> "$CONFIG"
    echo "maxClientCnxns=0" >> "$CONFIG"

    echo "clientPort=$ZOO_PORT" >> "$CONFIG"
    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$ZOO_LOG_DIR" >> "$CONFIG"

    echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
    echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done
fi

# Write myid only if it doesn't exist
echo ${MYID:-1} > /data/zookeeper/data/myid

exec "$@"
