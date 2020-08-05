#!/usr/bin/env bash


echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
echo

supervisorctl status
echo ----------------------------------------
redis-cli -h 127.0.0.1 -p 6379 cluster info | fgrep 'cluster_state:'
echo ----------------------------------------
redis-trib.rb check 127.0.0.1:6379