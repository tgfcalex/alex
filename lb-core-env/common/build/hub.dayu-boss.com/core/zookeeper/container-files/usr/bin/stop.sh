#!/usr/bin/env bash

echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
supervisorctl stop zookeeper

