#!/usr/bin/env bash
# by Tim
# 2019/08/21

set -e
if ! docker-compose -v &> /dev/null ; then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi
#sudo docker pull hub.dayu-boss.com:10443/site/site-ngx:1.15.8.2


cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
compose_file="${cur_dir}/docker-compose.yml"

cd ${cur_dir}

echo '
# -------------------- 1.  执行 python 脚本设置环境变量'
sudo ./get_info.py
source /etc/profile.d/custom_env.sh


echo '
# -------------------- 2. docker-compose 启容器:
'
echo docker-compose -f "${compose_file}" up -d "${composesrv}"

read -p "请输入'ok' ,按回车继续：" ok
docker-compose -f "${compose_file}" up -d "${composesrv}"
