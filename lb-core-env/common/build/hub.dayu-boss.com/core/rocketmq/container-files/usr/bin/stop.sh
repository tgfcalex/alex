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
        ;;
    namesrv)
        if jps | fgrep -q NamesrvStartup;then
            supervisorctl stop mqnamesrv
            mqshutdown namesrv
        fi
        ;;
    *)
        echo -e "\nUseage:\n\t$0  broker|namesrv\n"
        ;;
esac
