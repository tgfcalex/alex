# **lb环境部署**：

系统初始化
---

## 一. 系统初始化
```bash
1. 进入工程文件 ./env/common/ansible_init_system/
2. ansible-playbook core-init.yml
```
## 二. 安装docker, 运行之; build镜像
* 对所有服务器初始化完后，docker已安装完成；{docker-ce-17.09.1}
```bash
    # 先创建私有镜像仓库
    # op-core-env工程的 ./op-core-env/lb/deploy/00-tools/
       
    ./docker.register.sh   #修改了ip为lc的地址
``` 
```bash
    #根据docker file文件，build镜像，上传至镜像仓库
    #op-core-env工程的 ./op-core-env/build/docker-v17.09 目录下
    ./build.sh
```

## 三. 创建 swarm 集群
  
    # host列表:
    192.168.0.16     lc hub
    192.168.0.17     lg1
    192.168.0.18     lg2
    192.168.0.19     lg3


### 3.1 创建 swarm manager

    docker swarm init --advertise-addr 192.168.0.16

    # `docker info`和`docker node ls` 可以查看manager状态
    # 创建后输出带唯一token的join命令，其他节点可以依命令加入swarm

### 3.2 加入 swarm
    
    # 加入swarm有两种方式(manager|worker),可以在集群manager获取join-token，`docker swarm join-token (worker|manager)`
    # lc 操作:
    eval ansible lc -m shell -a \' $(docker swarm join-token worker | tail -3) \'

## 四. 部署集群

    # op-core-env工程的 ./lb/live/deploy/ 目录下，


### 4.1 给 host 打标签

    # 标签的作用: 让服务运行在指定标签下, (标签即 host)
    
    # 部署redis 3个节点
    docker node update  --label-add redis=1 lg1
    docker node update  --label-add redis=2 lg2
    docker node update  --label-add redis=3 lg3

    # 部署zookeeper 3个节点
    docker node update  --label-add zk=1 lg1 
    docker node update  --label-add zk=2 lg2
    docker node update  --label-add zk=3 lg3

    # 部署rocketmq 3个节点
    docker node update  --label-add mq=1 lg1
    docker node update  --label-add mq=2 lg2
    docker node update  --label-add mq=3 lg3

    # 部署tomcat 3个节点   
    docker node update  --label-add line=1 lg1
    docker node update  --label-add line=2 lg2
    docker node update  --label-add line=3 lg3

    # 部署ngx 2个节点    
    docker node update  --label-add ngx=true   lg1
    docker node update  --label-add ngx=true   lg2

    # 部署proxy 2个节点
    docker node update  --label-add squid=true lg1
    docker node update  --label-add squid=true lg2

#批量添加标签，针对标签将应用部署在不同的节点上
```bash
docker node update --label-add  redis=1  --label-add zk=1 --label-add mq=1 --label-add line=1 --label-add ngx=true --label-add squid=true  lg1
docker node update --label-add redis=2 --label-add zk=2 --label-add mq=2 --label-add line=2 --label-add ngx=true --label-add squid=true lg2
docker node update --label-add redis=3 --label-add zk=3 --label-add mq=3 --label-add line=3 --label-add ngx=true --label-add squid=true lg3
```
```bash
# 查看node 的标签信息   Labels

docker node inspect --pretty lg1   

```
### 4.2 创建集群的overlay网络
```bash    
    ./overlay_create.sh   
```
# 查看容器的网络
```bash
docker network ls
```
### 4.3 部署应用
        
     删除：   docker stack rm  rd
### 启动应用前，先拷贝conf文件和创建 应用需要挂载的目录
# 进入  ./lb/live/deploy/
```bash
ansible-playbook  copyConfMkdirDirectory-nginx.yml
```
         
#### 4.3.1 第三方应用 redis mq  zk

    # 进入 ./lb/live/deploy//01_shared  
    docker stack deploy -c redis.yml     rd    
    docker stack deploy -c zookeeper.yml zk    
    docker stack deploy -c rocketmq.yml  mq  
        
    # zookeeper和rocketmq可以根据配置自动发现并加入集群模式，
    # redis需要手动添加集群
```bash
# redis加入集群命令：
# 1.先查看部署rd服务在各节点的信息： （在lc上执行）
docker stack ps rd  #可以看到rd应用都部署在哪个节点，进入相应的节点，进入redis容器
# 2. 查看redis各节点使用的ip地址；
dsip
# 1.进入redis容器(使用以下命令，ip使用redis容器的ip)
redis-trib.rb  create --replicas 1 10.200.0.2:6379 10.200.0.4:6379 10.200.0.6:6379 10.200.0.8:6379 10.200.0.10:6379 10.200.0.12:6379
# 查看集群状态
redis-cli -c  cluster nodes 
redis-cli -c  cluster info
```

#### 4.3.2 tomcat 和 ngx

    # 进入 ./lb/live/deploy/02-tomcat-ngx    {line1,line2,line3}

# 注意部署ngx.yml时，要使用ansible 创建相应的目录和拷贝nginx的配置文件

## fserver部署时，需要注意fserver的data目录（/var/lb/data/fserver数据要同步）
## r1 和r2上运行fserver，/var/lb/data/fserver采用glusterfs分布式文件系统，复制模式，保证数据统一
执行命令： ansible-playbook  copyConfMkdirDirectory-nginx.yml    
  ```bash
  line1目录下：
    docker stack deploy  -c fserver-1.yml    lb         
    docker stack deploy -c tomcat-1.yml   lb                   
   line2目录下： 
    docker stack deploy -c fserver-2.yml lb
    docker stack deploy -c tomcat-2.yml lb
    line3目录下：
    docker stack deploy -c fserver-3.yml lb
    docker stack deploy -c tomcat-3.yml lb

    docker stack deploy  -c ngx.yaml   lb        
    docker stack deploy  -c proxy.yaml lb 
``` 
                