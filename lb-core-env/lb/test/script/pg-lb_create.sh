docker stop pg-lb.test
docker rm   pg-lb.test

docker run -itd --privileged --restart=always -p 5504:5432  --hostname=pg-lb.test --name=pg-lb.test  \
 -v /var/lb/data/pg/pg_lb/postgres:/var/data/postgres \
 -v /var/lb/data/pg/pg_lb/backup:/var/data/backup \
 -v /var/lb/data/pg/pg_lb/xlog_archive:/var/data/xlog_archive \
 hub:5000/gb-postgres-9.6

chown -R postgres:postgres /var/lb/data/pg/
chmod 700 /var/lb/data/pg/pg_lb/postgres/

