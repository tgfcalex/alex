#!/bin/bash
#zabbix_sender -z  210.17.64.140 -s check-im-dns -k  aaa  -o 200
#check="crm job"
#status=`curl --max-time 10 -k -s -o /dev/null -w '%{http_code}' https://crm.jet666.com/`
#echo `zabbix_sender -z  210.17.64.140 -s check-im-dns -k  "${check}.jet666.com"  -o $status`
function check_host(){
status=`curl --max-time 10 -k -s -o /dev/null -w '%{http_code}' https://${1}.jet666.com/`
echo `zabbix_sender -z  210.17.64.140 -s check-im-dns -k  "${1}.jet666.com"  -o $status`
}


check_host crm
check_host job
check_host admin
check_host smarttalk
#check_host api
check_host ws
check_host file
check_host robot
check_host dl
check_host www
check_host h5

status=`curl --max-time 10 -k -s -o /dev/null -w '%{http_code}' https://api.jet666.com/api`
echo `zabbix_sender -z  210.17.64.140 -s check-im-dns -k  "api.jet666.com"  -o $status`

