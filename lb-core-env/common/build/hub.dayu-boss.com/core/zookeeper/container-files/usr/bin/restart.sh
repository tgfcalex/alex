#!/usr/bin/env bash

echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
supervisorctl restart zookeeper

