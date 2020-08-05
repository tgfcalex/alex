FROM hub.dayu-boss.com/core/centos-base

ENV \
  JAVA_HOME="/usr/local/jre/" \
  PATH="/usr/local/jre/bin:$PATH" \
  CLASSPATH=.:/usr/local/jre/lib/rt.jar


RUN  set -ex \
  && jre_url="http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jre-8u171-linux-x64.tar.gz" \
  && jre_tar="jre-8u171-linux-x64.tar.gz" \
  && cd /usr/local/src/ \
  && curl --location --retry 3 -SLO \
    --header "Cookie: oraclelicense=accept-securebackup-cookie;" $jre_url \
  && tar xf $jre_tar  -C /usr/local/ \
  && ln -sv  /usr/local/jre1.8.0_171/ /usr/local/jre \
  \
  && yum install -y java-1.8.0-openjdk-devel-debug \
  && java -version \
  && jps \
# clean
  && rm -rf /usr/local/src/* \
  && yum clean all

ADD container-files /