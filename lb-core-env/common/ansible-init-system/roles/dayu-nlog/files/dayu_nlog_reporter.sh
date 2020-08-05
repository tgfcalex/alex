#!/usr/bin/env bash
set -e
if [ ! -d /var/dayu/nlog/bin ]; then
    python3 -m pip install virtualenv
    mkdir -p /var/dayu/
    cd /var/dayu/
    python3 -m virtualenv nlog
    source /var/dayu/nlog/bin/activate
    pip install -i http://dayu:VpyZMAlVVcnl2@pypi.gbboss.com:28888/simple/ --trusted-host pypi.gbboss.com dayu_nlog_reporter
    dayu_supervisor "dayu-nlog-reporter" -c "/var/dayu/nlog/bin/dayu_nlog_reporter"
    systemctl restart supervisord
    deactivate
else
    source /var/dayu/nlog/bin/activate
    pip install -U -i http://dayu:VpyZMAlVVcnl2@pypi.gbboss.com:28888/simple/ --trusted-host pypi.gbboss.com dayu_nlog_reporter
    supervisorctl restart dayu-nlog-reporter
    deactivate
fi