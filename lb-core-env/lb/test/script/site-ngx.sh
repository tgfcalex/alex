#!/usr/bin/env bash

docker stop site-ngx
docker rm site-ngx

site='-d --restart=always '

# ----------------- site
docker run ${site} \
    -p 80:80 \
    -p 443:443 \
    --name=site-ngx  \
    --hostname=site-ngx \
    -v /var/lb/conf/site-ngx:/usr/local/openresty/nginx/conf \
    -v /var/lb/logs/site-ngx:/data/nginx/logs \
    hub:5000/openresty

