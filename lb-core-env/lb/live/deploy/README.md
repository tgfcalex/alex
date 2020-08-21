
系统初始化
---

## 一. 系统初始化

## 二. 安装docker, 运行之; build镜像

    # 先创建私有镜像仓库
    # op-core-env工程的 ./op-core-env/deploy/sp/00-tools
       
        ./docker.register.sh

    #op-core-env工程的 ./op-core-env/build/docker-v17.09 目录下
    /var/env/common/build/docker-v17.09/build.sh 


## 三. 创建 swarm 集群
  
    # host列表:
     10.10.2.1       lc hub
    
    10.10.3.1       lt1
    10.10.3.2       lt2
    
    10.10.4.1       lr1
    10.10.4.2       lr2
    
    10.10.5.1       la1
    10.10.5.2       la2
    10.10.5.3       la3
    
    10.10.6.1       ld1
    10.10.6.2       ld2
    10.10.6.3       ld3
    
    10.10.7.1       lb1
    10.10.7.2       lb2
    10.10.7.3       lb3


### 3.1 创建 swarm manager

    docker swarm init --advertise-addr 10.10.2.1

    # `docker info`和`docker node ls` 可以查看manager状态
    # 创建后输出带唯一token的join命令，其他节点可以依命令加入swarm

### 3.2 加入 swarm
    
    # 加入swarm有两种方式(manager|worker),可以在集群manager获取join-token，`docker swarm join-token (worker|manager)`
    # lc 操作:
    eval ansible a,r,t,d,b -m shell -a \' $(docker swarm join-token worker | tail -3) \'

## 四. 部署集群

    # op-core-env工程的 ./lb/live/deploy/ 目录下，


### 4.1 给 host 打标签

    # 标签的作用: 让服务运行在指定标签下, (标签即 host)
    
    # 部署redis 3个节点
    docker node update  --label-add redis=1 lb1
    docker node update  --label-add redis=2 lb2
    docker node update  --label-add redis=3 lb3
    
    # 部署zookeeper 3个节点
    docker node update  --label-add zk=1 lb1 
    docker node update  --label-add zk=2 lb2
    docker node update  --label-add zk=3 lb3
    
    # 部署rocketmq 3个节点
    docker node update  --label-add mq=1 lb1
    docker node update  --label-add mq=2 lb2
    docker node update  --label-add mq=3 lb3
    
    # 部署tomcat 3个节点   
    docker node update  --label-add line=1 la1
    docker node update  --label-add line=2 la2
    docker node update  --label-add line=3 la3
    
    # 部署ngx 2个节点    
    docker node update  --label-add ngx=true   lr1
    docker node update  --label-add ngx=true   lr2
    docker node update  --label-add ngx=true   lt1
    docker node update  --label-add ngx=true   lt2
    
    # 部署proxy 2个节点
    docker node update  --label-add squid=true lt1
    docker node update  --label-add squid=true lt2

### 4.2 创建集群的overlay网络
        
    ./create-spnet.sh

### 4.3 部署应用
        
     删除：   docker stack rm  rd
         
#### 4.3.1 第三方应用 redis mq  zk

    # 进入 ./lb/live/deploy//01_shared    
    docker stack deploy -c redis.yml     rd
    docker stack deploy -c zookeeper.yml zk
    docker stack deploy -c rocketmq.yml  mq
        
    # zookeeper和rocketmq可以根据配置自动发现并加入集群模式，
    # redis需要手动添加集群

#### 4.3.2 tomcat 和 ngx

    # 进入 ./lb/live/deploy/02-tomcat-ngx
    docker stack deploy  -c a-line1.yaml         lb
    docker stack deploy  -c r-ngx.yaml           lb
    docker stack deploy  -c r-gather-client.yaml lb
        
