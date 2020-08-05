#!/usr/bin/env bash

set -e

site_id=$(echo $1 | tr -d ',')
key_pattern=${site_id}'_*'

for db in 2 4 7 8 ; do
    for i in $(redis-cli -a gamebox123 -n "$db"  --scan --pattern "$key_pattern") ; do
          redis-cli -a gamebox123 -n "$db" del "$i"
          echo -e $(TZ=Asia/Shanghai date +%F" "%X"  CST")"\t"$i  | tee -a /var/logs/html_flush.log
    done
done
# --------------------------------------
# gc-1 103.17.116.79    gc-2 103.37.233.32
# gc-3 103.90.136.119    gc-4 103.17.116.241
# gc-5 103.20.192.7
cdn_list='
    103.17.116.79
    103.37.233.32
    103.90.136.119
    103.17.116.241
    103.20.192.7
    '
case $site_id in
    189|135|167|196|192|141|177|226|119|218|313|360|553|585|528|217|238|568|706|369)
        if ! echo $HOSTNAME | grep -q '^gc-'; then
            for ip in $cdn_list; do
                curl -H  "Host:gamebox.com"  http://${ip}/__clear_html_cache\?siteid=$1
            done
        fi
        ;;
    *)
        true
        ;;
esac
