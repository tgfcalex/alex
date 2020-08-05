#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`

if [ -d /var/run/redis ]; then
    chown -R redis: /var/run/redis
fi

if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
    set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
    find . \! -user redis -exec chown redis '{}' +
    exec gosu redis "$0" "$@"
fi

exec "$@"

