#!/usr/bin/env bash


echo -e "
----------------------------------------
   Hostname:$(hostname)
----------------------------------------
"
case $1 in 
    broker)
        if jps | fgrep -q BrokerStartup;then
            supervisorctl stop mqbroker
            mqshutdown broker
        fi
        supervisorctl start mqbroker
        ;;
    namesrv)
        if jps | fgrep -q NamesrvStartup;then
            supervisorctl stop mqnamesrv
            mqshutdown namesrv
        fi
        supervisorctl start mqnamesrv
        ;;
    *)
        echo -e "\nUseage:\n\t$0  broker|namesrv\n"
        ;;
esac