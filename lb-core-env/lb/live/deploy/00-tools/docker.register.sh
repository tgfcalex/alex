#!/usr/bin/env bash


# 创建docker的镜像仓库，指定容器名和镜像数据的地址
# 指定 lc 地址

container_name="registry"
data_dir='/var/data/docker-registry'
host_ip='10.10.2.1'

if docker inspect "${container_name}" &> /dev/null; then
    docker stop ${container_name}
    docker rm ${container_name}
    sleep 5
fi

docker run -d \
    --restart=always \
    -p ${host_ip}:5000:5000 \
    --name ${container_name} \
    --hostname=${container_name} \
    -v ${data_dir}:/var/lib/registry \
    registry:2
