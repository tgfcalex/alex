#從git複製conf

scp -P 6343 -r /tmp/core-ngx.a/* la1:/var/lb/glusterfs/conf/core-ngx.a/
scp -P 6343 -r /tmp/core-ngx.a/* la2:/var/lb/glusterfs/conf/core-ngx.a/
scp -P 6343 -r /tmp/core-ngx.a/* la3:/var/lb/glusterfs/conf/core-ngx.a/
scp -P 6343 -r /tmp/core-ngx.r/* lr1:/var/lb/glusterfs/conf/core-ngx.r
scp -P 6343 -r /tmp/fserver/*    lr1:/var/lb/glusterfs/apps/fserver
scp -P 6343 -r /tmp/core-ngx.r/* lr2:/var/lb/glusterfs/conf/core-ngx.r
scp -P 6343 -r /tmp/fserver/*    lr2:/var/lb/glusterfs/apps/fserver
scp -P 6343 -r /var/env/lb/live/deploy/02-tomcat-ngx/core-ngx-r/*  lr1:/var/lb/deploy/coreNginx-fserver-r
scp -P 6343 -r /var/env/lb/live/deploy/02-tomcat-ngx/core-ngx-r/*  lr2:/var/lb/deploy/coreNginx-fserver-r


LT
scp -P 6343 /var/env/lb/live/deploy/02-tomcat-ngx/core-ngx-t.yml lt1:/var/lb/deploy/core-ngx/docker-compose.yml
scp -P 6343 /var/env/lb/live/deploy/02-tomcat-ngx/core-ngx-t.yml lt2:/var/lb/deploy/core-ngx/docker-compose.yml
scp -P 6343 -r /tmp/core-ngx-in/* lt1:/var/lb/conf/core-ngx-in/
scp -P 6343 -r /tmp/core-ngx-in/* lt2:/var/lb/conf/core-ngx-in/
scp -P 6343 -r /tmp/squid/* lt1:/var/lb/conf/squid/
scp -P 6343 -r /tmp/squid/* lt2:/var/lb/conf/squid/
scp -P 6343 -r /tmp/third-ngx/* lt1:/var/lb/conf/third-ngx
scp -P 6343 -r /tmp/third-ngx/* lt2:/var/lb/conf/third-ngx
scp -P 6343 -r /tmp/falcon-ngx/* lt1:/var/lb/conf/falcon-ngx/






#建立資料夾

#LA
 mkdir -p /var/lb/apps/official
 mkdir -p /var/lb/logs/official
 mkdir -p /var/lb/apps/cache-service
 mkdir -p /var/lb/data/mq/cache-service-rdb
 mkdir -p /var/lb/glusterfs/apps/pay-impl-jars
 mkdir -p /var/lb/logs/cache-service
 mkdir -p /var/lb/apps/hall
 mkdir -p /var/lb/data/mq/hall-rdb
 mkdir -p /var/lb/logs/hall
 mkdir -p /var/lb/data/mq/distributor-api-rdb
 mkdir -p /var/lb/apps/distributor-api
 mkdir -p /var/lb/logs/distributor-api
 mkdir -p /var/lb/data/mq/merchant-api-rdb
 mkdir -p /var/lb/apps/merchant-api
 mkdir -p /var/lb/logs/merchant-api
 mkdir -p /var/lb/apps/schedule
 mkdir -p /var/lb/data/mq/schedule-rdb
 mkdir -p /var/lb/logs/schedule
 mkdir -p /var/lb/apps/game-schedule
 mkdir -p /var/lb/data/mq/game-schedule-rdb
 mkdir -p /var/lb/logs/game-schedule
 mkdir -p /var/lb/apps/server
 mkdir -p /var/lb/data/mq/server-rdb
 mkdir -p /var/lb/glusterfs/apps/pay-impl-jars
 mkdir -p /var/lb/logs/server
 mkdir -p /var/lb/apps/mdcenter
 mkdir -p /var/lb/data/mq/mdcenter-rdb
 mkdir -p /var/lb/logs/mdcenter
 mkdir -p /var/lb/apps/manager
 mkdir -p /var/lb/data/mq/manager-rdb
 mkdir -p /var/lb/logs/manager
 mkdir -p /var/lb/logs/api
 mkdir -p /var/lb/apps/api
 mkdir -p /var/lb/data/mq/api-rdb
 mkdir -p /var/lb/logs/core-ngx.a
 mkdir -p /var/lb/script
 mkdir -p /var/lb/glusterfs/conf/core-ngx.a



#LB1
sudo mkdir -p /var/lb/logs/rocketmq/node1-m
sudo mkdir -p /var/lb/data/rocketmq/node1-m
sudo mkdir -p /var/lb/logs/rocketmq/node3-s
sudo mkdir -p /var/lb/data/rocketmq/node3-s
sudo mkdir -p /var/lb/data/zookeeper/zook-1
sudo mkdir -p /var/lb/logs/zookeeper/zook-1
sudo mkdir -p /var/lb/data/zookeeper/zook-6
sudo mkdir -p /var/lb/logs/zookeeper/zook-6

#LB2
sudo mkdir -p /var/lb/logs/rocketmq/node2-m
sudo mkdir -p /var/lb/data/rocketmq/node2-m
sudo mkdir -p /var/lb/logs/rocketmq/node1-s
sudo mkdir -p /var/lb/data/rocketmq/node1-s
sudo mkdir -p /var/lb/data/zookeeper/zook-2
sudo mkdir -p /var/lb/logs/zookeeper/zook-2
sudo mkdir -p /var/lb/data/zookeeper/zook-5
sudo mkdir -p /var/lb/logs/zookeeper/zook-5

#LB3
sudo mkdir -p /var/lb/logs/rocketmq/node3-m
sudo mkdir -p /var/lb/data/rocketmq/node3-m
sudo mkdir -p /var/lb/logs/rocketmq/node2-s
sudo mkdir -p /var/lb/data/rocketmq/node2-s
sudo mkdir -p /var/lb/data/zookeeper/zook-3
sudo mkdir -p /var/lb/logs/zookeeper/zook-3
sudo mkdir -p /var/lb/data/zookeeper/zook-4
sudo mkdir -p /var/lb/logs/zookeeper/zook-4


#LT
sudo mkdir -p /var/lb/logs/falcon-ngx
sudo mkdir -p /var/lb/conf/falcon-ngx
sudo mkdir -p /var/lb/conf/squid
sudo mkdir -p /var/lb/logs/squid
sudo mkdir -p /var/lb/conf/third-ngx
sudo mkdir -p /var/lb/logs/third-ngx
sudo mkdir -p /var/lb/conf/core-ngx-in
sudo mkdir -p /var/lb/logs/core-ngx-in
sudo mkdir -p /var/lb/script
sudo mkdir -p /var/lb/deploy/core-ngx

#LR
mkdir -p /var/lb/glusterfs/conf/core-ngx.r
mkdir -p /var/lb/logs/core-ngx.r
mkdir -p /var/lb/glusterfs/data/fserver/upload/data
mkdir -p /var/lb/glusterfs/apps/rcenter
mkdir -p /var/lb/glusterfs/apps/mobile-h5
mkdir -p /var/lb/glusterfs/apps/pc-h5
mkdir -p /var/lb/glusterfs/apps/api-h5
mkdir -p /var/lb/glusterfs/apps/newApi-h5
mkdir -p /var/lb/script
mkdir -p /var/lb/glusterfs/apps/web
mkdir -p /var/lb/glusterfs/apps/merchant-api-web
mkdir -p /var/lb/glusterfs/apps/distributor-api-web
mkdir -p /var/lb/glusterfs/apps/analyse
mkdir -p /var/lb/glusterfs/apps/fserver
mkdir -p /var/lb/logs/fserver
mkdir -p /var/lb/glusterfs/data/fserver/upload/tmp
mkdir -p /var/lb/glusterfs/data/fserver/upload/data
mkdir -p /var/lb/deploy/coreNginx-fserver-r