docker stop pg-lb.test
docker rm  pg-lb.test

docker run -itd --restart=always --privileged --net=bridge --hostname=pg-lb.test -p 5504:5432 --name pg-lb.test  \
 -v /var/lb/data/pg/pg_lb_10/backup:/var/data/backup \
 -v /var/lb/data/pg/pg_lb_10/postgres:/var/data/postgres \
 -v /var/lb/data/pg/pg_lb_10/xlog_archive:/var/data/xlog_archive \
 hub:5000/centos-pg10.1:latest

chown -R postgres:postgres /var/lb/data/pg/pg_lb_10/
chmod 700 /var/lb/data/pg/pg_lb_10/postgres/

