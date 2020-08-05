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

cat <<EOF > /usr/local/tomcat/webapps/ROOT/WEB-INF/dubbo.properties
dubbo.registry.address=zookeeper://${ZOO_ADD:-127.0.0.1:2181}
dubbo.admin.root.password=root
dubbo.admin.guest.password=guest
EOF

exec "$@"
