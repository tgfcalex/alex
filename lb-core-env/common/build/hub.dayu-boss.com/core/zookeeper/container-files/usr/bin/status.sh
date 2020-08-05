#!/usr/bin/env bash

echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
supervisorctl status
echo ----------------------------------------
zkServer.sh status
echo  
