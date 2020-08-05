FROM hub.dayu-boss.com/core/tomcat

RUN \
  set -ex \
  && yum install -y mailcap php libmcrypt mhash php-mcrypt libmcrypt-devel \
  && yum clean all
