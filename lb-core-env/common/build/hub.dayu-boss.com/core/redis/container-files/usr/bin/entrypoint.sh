#!/usr/bin/env bash

# Author: Tim
# Date  : 17-11-10

#
mkdir -p /var/redis/{conf,log}
chown -R redis: /var/redis/

exec "$@"