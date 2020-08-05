#!/usr/bin/env bash


echo "
----------------------------------------
               Hostname:$(hostname)
----------------------------------------
"
supervisorctl start tomcat
