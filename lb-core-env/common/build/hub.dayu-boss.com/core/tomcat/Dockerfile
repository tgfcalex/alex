FROM hub.dayu-boss.com/core/centos-jre8

ENV CATALINA_HOME=/usr/local/tomcat \
    PATH=/usr/local/tomcat/bin/:$PATH \
    JAVA_OPT="-Xms2048m -Xmx2048m -Xmn2g -Xss256k"
#      ↑↑↑↑↑↑↑↑↑↑↑
# /usr/bin/entrypoint.sh有设置 export JAVA_OPTS="$JAVA_OPT ......"
# 所以只需要赋值 JAVA_OPT

# apache-tomcat-7.0.67.tar.gz是自修改版本，有添加私有.jar
ADD apache-tomcat-7.0.67.tar.gz  /usr/local/tomcat/

ADD container-files /
RUN set -ex \
  \
  && cd /usr/local/tomcat/ \
  && sed -i 's/\"\$CATALINA_BASE\"\/logs\/catalina.out/\/dev\/null/g' ./bin/catalina.sh \
  \
  && yum install -y openssl-devel apr-devel nginx \
  && chmod +x /usr/bin/{entrypoint,restart,setenv,start,stop}.sh ./bin/*.sh \
  \
  && rm -rf ./bin/*.bat ./webapps/* \
  && yum clean all

WORKDIR /usr/local/tomcat/bin/
EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=8s --retries=3 \
    CMD port_check 8080
