#!/bin/bash

tee << EOF >> /etc/sysctl.conf
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
kernel.shmmni = 4096
fs.file-max = 7672460
net.ipv4.ip_local_port_range = 9000 65000
net.core.rmem_default = 1048576
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
kernel.sem = 50100 64128000 50100 1280
EOF
