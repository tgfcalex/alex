#!/bin/bash

data=`/usr/bin/redis-cli -h 172.21.1.15 -p 6379 -a helo info 2>/dev/null | grep -w used_memory | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.master.used_memory -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.15 -p 6379 -a helo info 2>/dev/null | grep -w connected_clients | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.master.connected_clients -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.15 -p 6379 -a helo info 2>/dev/null | grep -w instantaneous_input_kbps | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.master.instantaneous_input_kbps -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.15 -p 6379 -a helo info 2>/dev/null | grep -w instantaneous_ops_per_sec | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.master.instantaneous_ops_per_sec -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.15 -p 6379 -a helo info 2>/dev/null | grep -w keyspace_misses | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.master.keyspace_misses -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.15 -p 6379 -a helo info 2>/dev/null | grep -w expired_keys | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.master.expired_keys -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.16 -p 6380 -a helo info 2>/dev/null | grep -w used_memory | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-1.used_memory -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.16 -p 6380 -a helo info 2>/dev/null | grep -w connected_clients | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-1.connected_clients -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.16 -p 6380 -a helo info 2>/dev/null | grep -w instantaneous_input_kbps | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-1.instantaneous_input_kbps -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.16 -p 6380 -a helo info 2>/dev/null | grep -w instantaneous_ops_per_sec | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-1.instantaneous_ops_per_sec -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.16 -p 6380 -a helo info 2>/dev/null | grep -w keyspace_misses | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-1.keyspace_misses -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.16 -p 6380 -a helo info 2>/dev/null | grep -w expired_keys | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-1.expired_keys -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.17 -p 6381 -a helo info 2>/dev/null | grep -w used_memory | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-2.used_memory -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.17 -p 6381 -a helo info 2>/dev/null | grep -w connected_clients | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-2.connected_clients -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.17 -p 6381 -a helo info 2>/dev/null | grep -w instantaneous_input_kbps | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-2.instantaneous_input_kbps -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.17 -p 6381 -a helo info 2>/dev/null | grep -w instantaneous_ops_per_sec | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-2.instantaneous_ops_per_sec -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.17 -p 6381 -a helo info 2>/dev/null | grep -w keyspace_misses | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-2.keyspace_misses -o ${data}

data=`/usr/bin/redis-cli -h 172.21.1.17 -p 6381 -a helo info 2>/dev/null | grep -w expired_keys | awk -F ':' '{print $NF}'`
/usr/bin/zabbix_sender -z  172.21.1.5 -s redis -k redis.slave-2.expired_keys -o ${data}
