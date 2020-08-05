# **生产测试线部署**
### 文档说明
> 用于程序发包，先更新测试线，验证通过，然后更新生产线,完全模拟生产环境

> 所有应用挂载的文件路径： /var/v-lb/{conf,apps,logs}

### 部署
- 测试线只部署一条线路  la1运行测试线
> 1.创建tomcat的挂载路径,la1上执行
```bash
# 目录创建完成后，将各应用的程序包拷贝至/var/v-lb/apps/ 目录下

mkdir -pv /var/v-lb/{apps,logs,data}
mkdir -pv /var/v-lb/data/mq/{api-rdb,cache-service-rdb,game-schedule-rdb,hall-rdb,manager-rdb,mdcenter-rdb,schedule-rdb,server-rdb}
mkdir -pv /var/v-lb/logs/{api,cache-service,game-schedule,hall,manager,mdcenter,schedule,server}
```
> 2.进入/var/env/lb/live/deploy/02-tomcat-ngx/v-line/v-core-ngx-a.yml，lc上执行
```bash
docker stack deploy -c v-tomcat-service.yml v
docker stack deploy -c v-tomcat-app.yml  v

```

> 3.nginx部署，lr1
```bash
# 3.1 lr1创建挂载目录

mkdir -pv /var/v-lb/{conf,logs,apps,data}
mkdir -pv /var/v-v-lb/logs/core-ngx
mkdir -pv /var/v-lb/apps/{rcenter,mobile-h5,pc-h5}

# 3.2 拷贝配置文件至lr1  /var/v-lb/conf/core-ngx
# 3.3 拷贝静态资源程序包至/var/v-lb/apps/ 目录下
# 3.4  进入/var/env/lb/live/deploy/02-tomcat-ngx/v-core-ngx/,lc上执行
# 测试线nginx只部署一条线路，node节点lr1打标签 v-ngx=true

docker node update --label-add v-ngx=true lr1
docker stack deploy -c v-ngx.yml v
```

- 部署过程中，需要注意的就是容器的挂载目录是否创建，docker stack创建的容器，不会自动创建挂载目录！
- 测试线需要注意，要和生产线可以隔离开，保证测试线的服务加入zookeeper中，不会和生产线共联！
              