#!/usr/bin/env bash

set -e
tee << EOF >> /home/postgres/.bash_profile
export PGUSER=postgres
export PGPORT=5432
export PGDATA=/var/data/postgres
export PGHOME=/usr/local/postgres
export PATH=$PGHOME/bin:$PATH
export LD_LIBRARY_PATH=$PGHOME/lib:$LD_LIBRARY_PATH
export MANPATH=/usr/local/pgsql/share/man:$MANPATH
export LANG=en_US.utf8
export DATATIME=`date +"%Y%m%d%H%M"`

EOF

for i in /user-conf/.psqlrc /user-conf/.vimrc; do
    if [[ -f "$i" ]]; then
        su postgres -c "cp $i /home/postgres/"
    fi
done

source /home/postgres/.bash_profile

exec "$@"
