#!/usr/bin/env bash

docker stop lb_server-1 lb_cache-service-1 lb_mobile-1 lb_mdcenter-1 lb_schedule-1 lb_hall-1 lb_manager-1 lb_api-1 lb_game-schedule-1 lb_fserver-1
docker rm   lb_server-1 lb_cache-service-1 lb_mobile-1 lb_mdcenter-1 lb_schedule-1 lb_hall-1 lb_manager-1 lb_api-1 lb_game-schedule-1 lb_fserver-1
exp_ops='-tid --restart=always --net=lb_net '

_enter_go_on(){
    read -p "        请按回车继续..." var
}


_enter_go_on

# ----------------- api
docker run ${exp_ops} \
    --ip=10.60.10.1 \
    --name=lb_api-1 \
    --hostname=lb_api-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/api-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/api:/usr/local/tomcat/webapps/api \
    -v /var/lb/logs/api:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- manager
docker run ${exp_ops} \
    --ip=10.60.20.1 \
    --name=lb_manager-1 \
    --hostname=lb_manager-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/manager-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/manager:/usr/local/tomcat/webapps/manager \
    -v /var/lb/logs/manager:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- hall
docker run ${exp_ops} \
    --ip=10.60.30.1 \
    --name=lb_hall-1 \
    --hostname=lb_hall-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/hall-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/hall:/usr/local/tomcat/webapps/ROOT \
    -v /var/lb/logs/hall:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- schedule
docker run ${exp_ops} \
    --ip=10.60.40.1 \
    --name=lb_schedule-1 \
    --hostname=lb_schedule-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/schedule-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/schedule:/usr/local/tomcat/webapps/schedule \
    -v /var/lb/logs/schedule:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- mdcenter
docker run ${exp_ops} \
    --ip=10.60.50.1 \
    --name=lb_mdcenter-1 \
    --hostname=lb_mdcenter-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/mdcenter-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/mdcenter:/usr/local/tomcat/webapps/mdcenter \
    -v /var/lb/logs/mdcenter:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- mobile
#docker run ${exp_ops} \
#    --ip=10.60.60.1 \
#    --name=lb_mobile-1 \
#    --hostname=lb_mobile-1 \
#	-p 8080:8080 \
#    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
#    -v /var/lb/data/mq/mobile-rdb:/var/data/mq/rdb \
#    -v /var/lb/apps/mobile:/usr/local/tomcat/webapps/mobile \
#    -v /var/lb/logs/mobile:/usr/local/tomcat/logs/ \
#    hub:5000/tomcat-php

# ----------------- server
docker run ${exp_ops} \
    --ip=10.60.70.1 \
    --name=lb_server-1 \
    --hostname=lb_server-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/server-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/server:/usr/local/tomcat/webapps/server \
    -v /var/lb/apps/pay-impl-jars:/data/impl-jars/pay \
    -v /var/lb/logs/server:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- game-schedule
docker run ${exp_ops} \
    --ip=10.60.80.1 \
    --name=lb_game-schedule-1 \
    --hostname=lb_game-schedule-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/game-schedule-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/game-schedule:/usr/local/tomcat/webapps/game-schedule \
    -v /var/lb/logs/game-schedule:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- cache-service
docker run ${exp_ops} \
    --ip=10.60.90.1 \
    --name=lb_cache-service-1 \
    --hostname=lb_cache-service-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/mq/cache-service-rdb:/var/data/mq/rdb \
    -v /var/lb/apps/cache-service:/usr/local/tomcat/webapps/cache-service \
    -v /var/lb/apps/pay-impl-jars:/data/impl-jars/pay \
    -v /var/lb/logs/cache-service:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php

# ----------------- fserver
docker run ${exp_ops} \
    --ip=10.60.230.1 \
    -p 93:8080 \
    --name=lb_fserver-1 \
    --hostname=lb_fserver-1 \
    -e JAVA_OPT="-Xms2500m -Xmx2500m -Xmn2g" \
    -v /var/lb/data/fserver/upload/tmp:/data/upload/tmp/ \
    -v /var/lb/data/fserver/upload/data:/data/upload/data/ \
    -v /var/lb/apps/ftl:/data/ftl/ \
    -v /var/lb/apps/fserver:/usr/local/tomcat/webapps/fserver/ \
    -v /var/lb/logs/fserver:/usr/local/tomcat/logs/ \
    hub:5000/tomcat-php
