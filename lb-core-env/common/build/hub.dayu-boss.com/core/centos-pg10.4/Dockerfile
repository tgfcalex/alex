FROM centos:7

ENV PGUSER=postgres \
    PGPORT=5432 \
    PGUID=1000 \
    \
    PGDATA=/var/data/postgres \
    PGHOME=/usr/local/postgres \
    \
    PATH=$PGHOME/bin/psql:$PATH \
    \
    LD_LIBRARY_PATH=$PGHOME/lib \
    MANPATH=/usr/local/pgsql/share/man:$MANPATH

RUN set -ex \
#    && sh /sysctl_conf.sh \
#    \

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

  && build_DEV=' gcc make \
        perl-ExtUtils-Embed readline-devel \
        zlib-devel pam-devel libxml2-devel \
        libxslt-devel openldap-devel openssl-devel\
        tcl-devel python-devel openssh-clients \
        ' \
  && yum install -y epel-release.noarch \
  && yum clean all \
  && yum install -y $yum_install_tools ${build_DEV} \

# install supervisor
  && yum install -y python-pip \
  && pip install --upgrade pip \
  && pip install --upgrade supervisor \
  \
  && supervisord -v \

# create USER
    && groupadd -g $PGUID $PGUSER \
    && useradd -u $PGUID -g $PGUID $PGUSER \
    && mkdir -p /var/data/{postgres,backup,xlog_archive} \
    && chown -R $PGUSER: /var/data \
    \
    && yum install -y sudo \
    && echo "$PGUSER    ALL=(ALL)  NOPASSWD:    ALL" >> /etc/sudoers \
    \
# compile & install pgSQL
    && pg_version="10.4"\
    && file_name="postgresql-$pg_version.tar.gz" \
    && pgsql_URL="https://ftp.postgresql.org/pub/source/v$pg_version/$file_name" \
    && pgsql_MD5="https://ftp.postgresql.org/pub/source/v$pg_version/$file_name.md5" \
    \
    && curl -SL $pgsql_URL -o $file_name \
    && curl $pgsql_MD5 | md5sum -c \
    \
    && compile_DIR=`mktemp -d` \
    && tar xf $file_name -C $compile_DIR --strip-components=1 \
    \
    && rm -f $file_name \
    \
    && cd $compile_DIR \
    && ./configure \
        --prefix=/usr/local/postgres \
        --with-pgport=5432 \
        --with-perl \
        --with-tcl \
        --with-python \
        --with-openssl \
        --with-pam \
        --with-libxml \
        --with-libxslt \
        --enable-thread-safety \
        --with-wal-blocksize=16 \
        --with-blocksize=8 \
    && gmake world \
    && gmake install-world \
    \
# clean
  && rm -rf /root/.cache/pip/* \
  && cd \
  && rm -rf $compile_DIR \
  && yum remove -y gcc make \
  && yum clean all

ADD container-files /

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/entrypoint.sh"]
CMD [ "/usr/bin/supervisord" ]
