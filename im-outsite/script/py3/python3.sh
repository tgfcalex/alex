#!/usr/bin/env bash
yum -y install wget gcc zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
yum install libffi-devel -y
rm -rf /root/Python-3.6.5
rm -f /root/Python-3.6.5.tgz
mkdir /var/dayu/tmp/ -p
if [[ ! -d /var/dayu/tmp/Python-3.7.1 ]]; then
    if [[ ! -f /var/dayu/tmp/Python-3.7.1.tgz ]] ; then
      wget -P /var/dayu/tmp/ https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tgz
    fi
    tar -C /var/dayu/tmp -xzf /var/dayu/tmp/Python-3.7.1.tgz
fi
mkdir -p /usr/local/python3.7.1
cd /var/dayu/tmp/Python-3.7.1
./configure --prefix=/usr/local/python3.7
make && make install
rm -f /usr/bin/python3
rm -rf /var/dayu/tmp/Python-3.7.1
ln -s /usr/local/python3.7/bin/python3 /usr/bin/python3
