#!/usr/bin/env bash

# Author: Tim

if [[ -d /var/log/squid/ ]]; then
    chown -R squid: /var/log/squid/
fi

exec "$@"
