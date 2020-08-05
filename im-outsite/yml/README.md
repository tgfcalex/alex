# 说明

## 基于 docker-compose 部署应用

## get_info.py 从主机名进行环境匹配

## run.sh ：

    1. 安装 docker-compose;
    2. 从 get_info.py 获取环境变量, 写入 /etc/profile.d/sp_env.sh;
    3. 工程 ./script/sh/ 添加到 $PATH ， 写入 /etc/profile;
    4. docker-compose 部署容器。
