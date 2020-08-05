
系统初始化
---

## 一. 系统初始化
```bash
1. 进入工程文件 ./env/common/ansible_init_system/
2. ansible-playbook core-init.yml
3.  Git Pull   ssh://git@lbgit.lasyo.com:991/ops/lb-core-env.git 
```

## 二. 创建 swarm 集群
  
    # host列表/etc/hosts:
	
	
    10.10.2.1       lc
    
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
	
	#/etc/ansible/hosts
	[c]
    lc

    [a]
    la1
    la2
    la3

    [b]
    lb1
    lb2
    lb3

    [r]
    lr1
    lr2

    [d]
    ld1
    ld2
    ld3
	
    [t]
    lt1
    lt2


### 3.1 创建 swarm manager

    docker swarm init --advertise-addr 10.10.2.1

    # `docker info`和`docker node ls` 可以查看manager状态
	
    # 创建后输出带唯一token的join命令，其他节点可以依命令加入swarm

### 3.2 加入 swarm
    
    # 加入swarm有两种方式(manager|worker),可以在集群manager获取join-token，`docker swarm join-token (worker|manager)`
	
    # lc 操作:
     ansible a,b,r,t,d -m shell -a \' $(docker swarm join-token worker | tail -3) \'

## 四. 部署集群

    # op-core-env工程的 ./lb/live/deploy/ 目录下，
    # 添加防火牆(每台主機都需要)
	cp ./lb/live/deploy/nginx_dir_conf.md/docker-swarm.xml /usr/lib/firewalld/services/
	
    firewall-cmd --add-service=docker-swarm --permanent
    firewall-cmd --add-service=docker-swarm
    #添加op使用docker權限(每台主機都需要)
	usermod -aG docker op
	
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
    docker node update  --label-add a-ngx=true la1
    docker node update  --label-add a-ngx=true la2
    docker node update  --label-add a-ngx=true la3
    
    # 部署ngx 2个节点    
    docker node update  --label-add ngx=true   lt1
    docker node update  --label-add ngx=true   lt2
    
    # 部署proxy 2个节点
    docker node update  --label-add squid=true lt1
    docker node update  --label-add squid=true lt2
    docker node update  --label-add monitor=true lt1
    docker node update  --label-add proxy=true lt2
    docker node update  --label-add third=true lt1
    docker node update  --label-add third=true lt2

### 4.2 创建集群的overlay网络
        
    ./create-spnet.sh

### 4.3 部署应用
    
	#建造nginx必要的資料夾
	依照./lb/live/deploy/nginx_dir_conf.md 建立 & 複製必要的conf & dir
	
	#Pull Images
    ansible b -m shell -a "sudo docker pull hub.dayu-boss.com/core/redis:swarm"
    ansible b -m shell -a "sudo docker pull hub.dayu-boss.com/core/rocketmq"
    ansible b -m shell -a "sudo docker pull hub.dayu-boss.com/core/zookeeper"
    ansible a,r -m shell -a "sudo docker pull hub.dayu-boss.com/core/tomcat"
    ansible a,c,r,t -m shell -a "sudo docker pull hub.dayu-boss.com/core/openresty"
    ansible t -m shell -a "sudo docker pull hub.dayu-boss.com/core/squid"
    ansible t -m shell -a"sudo docker pull hub.dayu-boss.com/core/rocketmq-console-ng:styletang"
    ansible a -m shell -a "sudo docker pull hub.dayu-boss.com/core/tomcat-php"
         
#### 4.3.1 第三方应用 redis mq  zk



    # 在LC建立Docker Swarm 服務集群  
    
    #LC
	cd /var/env/lb/live/deploy/00-tools
	docker-compose up -d
    
    #LA
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/tomcat-1.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/tomcat-2.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/tomcat-3.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/distributor-api-1.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/distributor-api-2.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/distributor-api-3.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/official.yaml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/core-ngx-a.yml lb
    
    
    #LB
    docker stack deploy -c  /var/env/lb/live/deploy/01_shared/redis.yml dt
    docker stack deploy -c  /var/env/lb/live/deploy/01_shared/redis.yml ss
    docker stack deploy -c  /var/env/lb/live/deploy/01_shared/zookeeper.yml zk
    docker stack deploy -c  /var/env/lb/live/deploy/01_shared/rocketmq.yml mq
    
    #LT
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/t-ngx.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/proxy.yml  lb
    docker stack deploy -c  /var/env/lb/live/deploy/02-tomcat-ngx/falcon-ngx.yml lb
    docker stack deploy -c  /var/env/lb/live/deploy/01_shared/rocketmq-web.yml mq
    #進LT
    sudo chown op:op -R /var/lb/
    cd /var/lb/deploy/core-ngx
    docker-compose up -d
    
    #進LR
    sudo chown op:op -R /var/lb/
    cd /var/lb/deploy/coreNginx-fserver-r
    docker-compose up -d
        

    #B服務器redis需要手动添加集群

    # lc查詢各容器ip
    ansible b -m shell -a "rectn ss_ ip a | grep 10.100."
    ansible b -m shell -a "rectn dt_ ip a | grep 10.100."
    
    # 進B服務器的ss & dt容器加集群
    ctn ss_rd-6.1
    redis-trib.rb create --replicas 1 <六台容器IP:6379>
    ctn dt_rd-6.1
    redis-trib.rb create --replicas 1 <六台容器IP:6379>
        
