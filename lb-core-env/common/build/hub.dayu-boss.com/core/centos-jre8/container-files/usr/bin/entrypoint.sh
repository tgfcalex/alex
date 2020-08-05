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

exec "$@"
