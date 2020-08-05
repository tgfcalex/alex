nginx部署描述  - 2018.9.12
- r部署nginx
  -- r脱离集群，在r上使用docker-compose部署core-ngx
  -- 命令:  (docker-compose.yml文件位于core-ngx-r目录下)
    docker-compose up -d

- a部署nginx
  -- 使用docker stack 部署，分布在a1 a2 a3三个节点
  -- 命令：
    docker stack deploy -c core-ngx-a.yml  lb