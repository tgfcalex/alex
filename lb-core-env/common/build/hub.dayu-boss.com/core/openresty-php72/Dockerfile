FROM hub.dayu-boss.com/core/openresty

ADD container-files /
RUN \
  set -ex \
  && yum install -y http://remi.conetix.com.au/enterprise/remi-release-7.rpm \
  && yum makecache \
  && yum install -y php72-php-fpm php72-php-mysqlnd php72-php-pecl-mysql php72-php-xml \
  && yum clean all
