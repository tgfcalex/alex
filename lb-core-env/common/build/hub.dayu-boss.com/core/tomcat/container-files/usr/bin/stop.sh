#!/usr/bin/env bash


echo "
----------------------------------------
               Hostname:$(hostname)
----------------------------------------
"
supervisorctl stop tomcat
