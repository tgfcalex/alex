#!/usr/bin/env bash


echo "
----------------------------------------
               Hostname:$(hostname)
----------------------------------------
"
supervisorctl restart tomcat
