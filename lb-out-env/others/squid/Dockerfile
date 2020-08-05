FROM centos:7.6.1810

RUN \
  set -ex \
# ------------------------------------------------- centos-base start -------------------------------------------------
# add epel repo & install tools
  && yum install -y epel-release.noarch \

# install supervisor
  && yum install -y squid iproute \

# clean
  && yum clean all \
  && yum history new

COPY ./squid.conf    /etc/squid/squid.conf
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

WORKDIR /var/log/squid/

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD  [ "squid", "-f", "/etc/squid/squid.conf","-N" ]
