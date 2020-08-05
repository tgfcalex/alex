# ***compose文件说明***

### v-core-ngx-r
> r 脱离集群，此目录下的docker-compose.yml文件，用来部署core-ngx,代理请求到a上
> 部署命令： docker-compose  up -d

### v-core-ngx-a.yml文件
> 此文件用来部署nginx到a上
> 部署命令： docker stack deploy -c v-core-ngx-a.yml  v

### v-tomcat-app.yml v-tomcat-service.yml
> 这两个文件将tomcat拆分为应用和服务
> 部署命令: 
>   docker stack deploy -c v-tomcat-service.yml v
>   docker stack deploy -c v-tomcat-app.yml  v


### tomcat
> 1. swarm在部署单节点多服务的时候，会出现响应daemon端超时问题，容器启动失败
> 2. tomcat部署拆分为服务 和应用