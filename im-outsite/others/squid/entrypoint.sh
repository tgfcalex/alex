#!/bin/bash

# Author: Tim

set -e
if [[ -d /var/log/squid/ ]]; then
    chown -R squid: /var/log/squid/
fi

if [[ -d /var/spool/squid/ ]]; then
    chown -R squid: /var/spool/squid/
fi

exec "$@"
