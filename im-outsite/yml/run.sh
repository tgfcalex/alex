#!/usr/bin/env bash
# by Tim
# 2019/08/21

set -e
if ! docker-compose -v &> /dev/null ; then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
cd ${cur_dir}
compose_file="${cur_dir}/docker-compose.yml"


echo -e "准备创建容器， 环境变量为：\n"
if python2 ${cur_dir}/get_info.py; then
    env_cmd=$(python2 ${cur_dir}/get_info.py)
fi

echo '
# ------- 设置环境变量
'
read -p "请输入'ok' ,按回车继续：" ok
if [[ -d "/var/im/site-out/script/sh/" ]] && ! fgrep -q /var/im/site-out/script/sh /etc/profile &> /dev/null; then
    echo -e "\nexport PATH=/var/im/site-out/script/sh/:\$PATH" | sudo tee -a /etc/profile
fi
echo -e "${env_cmd}\nexport platform idc composesrv stype" | sudo tee /etc/profile.d/im_env.sh

echo '
# ------- docker-compose 启容器
'
docker pull hub.dayu-boss.com:10443/site/site-ngx:1.15.8.2
read -p "请输入'ok' ,按回车继续：" ok
eval export ${env_cmd}
docker-compose -f "${compose_file}" up -d "${composesrv}"

echo '
# ------- 创建nginx日志的软连接
'
ln -sf  /var/im/logs/access.log /home/op/access.log
ln -sf  /var/im/logs/error.log /home/op/error.log
