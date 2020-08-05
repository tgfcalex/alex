FROM centos:7

RUN \
  set -ex \

# ------------------------------------------------- centos-base start -------------------------------------------------
# add epel repo & install tools
  && yum_install_tools="\
    iproute \
    iftop \
    net-tools \
    telnet \
    tree \
    vim \
    unzip \
    which \
    tree \
    file \
    nload \
    nmap \
    nmap-ncat \
    less \
    mtr \
    traceroute \
    mlocate \
    bash-completion \
    bash-completion-extras \
    " \
  && yum install -y epel-release.noarch \
  && yum clean all \
  && yum install -y $yum_install_tools \

# install supervisor
  && yum install -y python-pip \
  && pip install --upgrade pip \
  && pip install supervisor \
  && supervisord -v \

# clean
  && rm -rf /root/.cache/pip/* \
  && yum clean all \
  && yum history new

ADD container-files /
ENV LANG=en_US.UTF-8

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
