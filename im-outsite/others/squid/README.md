# 说明

1. 基于squid的正向代理,开放10080端口;
2. 挂载目录: /var/log/squid/:/var/log/squid/, /var/spool/squid/:/var/spool/squid/;
3. 依赖docker-compose;
4. 执行: docker-compose up -d --build

## 安装 docker-compose

```bash

sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

```
