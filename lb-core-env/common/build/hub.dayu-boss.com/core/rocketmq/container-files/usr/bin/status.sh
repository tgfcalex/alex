#!/usr/bin/env bash


echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
supervisorctl status

echo '----------------------------------------'
mqadmin clusterList  -n `hostname -i`:9876