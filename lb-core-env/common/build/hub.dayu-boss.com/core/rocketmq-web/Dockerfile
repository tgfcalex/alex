FROM hub.dayu-boss.com/core/tomcat

COPY rocketmq-console-SNAPSHOT-1.0.war /
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN set -ex \
  && rm -rf /usr/local/tomcat/webapps/* \
  && mkdir /usr/local/tomcat/webapps/ROOT \
  \
  && cd /usr/local/tomcat/webapps/ROOT \
  && mv /rocketmq-console-SNAPSHOT-1.0.war . \
  \
  && echo '415dcbfc3acf263414068865f04187c5  rocketmq-console-SNAPSHOT-1.0.war' | md5sum -c - \
  && unzip rocketmq-console-SNAPSHOT-1.0.war &>/dev/null \
  \
  && chmod +x /usr/bin/entrypoint.sh \
  && rm -rf rocketmq-console-SNAPSHOT-1.0.war
#ENV JAVA_OPTS=$JAVA_OPTS:" -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

