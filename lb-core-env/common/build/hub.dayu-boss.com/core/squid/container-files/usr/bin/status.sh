#!/usr/bin/env bash


echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
supervisorctl status
