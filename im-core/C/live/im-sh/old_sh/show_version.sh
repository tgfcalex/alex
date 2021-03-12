#!/bin/sh
# yml路徑
path="/var/env/im/live/deploy/yml"
# 未拆的坑
admio="hub.chats-boss.com/im/* | awk -F ':' '{print ${3}}'"
# 取yml內image版本
admin=`cat $path/admin.yml | grep hub.chats-boss.com/im/* | awk -F ':' '{print $3}' `
api=`cat $path/api.yml | grep hub.chats-boss.com/im/* | awk -F ':' '{print $3}'`
chatbot=`cat $path/chatbot.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
file=`cat $path/file.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
gateway=`cat $path/gateway.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
push=`cat $path/push.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
robot=`cat $path/robot.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
server=`cat $path/server.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
services=`cat $path/services-cmd.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
smarttalk=`cat $path/smarttalk.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
task=`cat $path/task.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
user=`cat $path/user.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
webdownload=`cat $path/web-download.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
website=`cat $path/website-cmd.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
websmarttalk=`cat $path/web-smarttalk-cmd.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`

#取運行中的服務image版本
ymladmin=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_admin |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlapi=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_api |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlchatbot=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_chatbot |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlfile=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_file |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlgateway=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_gateway |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlpush=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_push |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlrobot=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_robot |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlserver=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_server |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlservices=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_services |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlsmarttalk=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymltask=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_task |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymluser=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_user |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlwebdownload=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_web_download |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlwebsite=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_jm_website |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlwebsmarttalk=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_web_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $1}'`

#取運行中的服務位置
mladmin=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_admin |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlapi=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_api |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlchatbot=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_chatbot |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlfile=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_file |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlgateway=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_gateway |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlpush=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_push |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlrobot=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_robot |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlserver=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_server |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlservices=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_services |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlsmarttalk=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mltask=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_task |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mluser=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_user |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlwebdownload=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_web_download |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlwebsite=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_jm_website |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlwebsmarttalk=`docker stack ps im | grep Running | grep hub.chats-boss.com/im/im_web_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $2}'`


if [ $admin = $ymladmin ];then
trueadmin="相 同"
else
trueadmin="*異常"
fi

if [ $api = $ymlapi ];then
trueapi="相 同"
else
trueapi="*異常"
fi

if [ $chatbot = $ymlchatbot ];then
truechatbot="相同"
else
truechatbot="異常"
fi

if [ $file = $ymlfile ];then
truefile="相同"
else
truefile="異常"
fi

if [ $gateway = $ymlgateway ];then
truegateway="相同"
else
truegateway="異常"
fi

if [ $push = $ymlpush ];then
truepush="相同"
else
truepush="異常"
fi

if [ $robot = $ymlrobot ];then
truerobot="相同"
else
truerobot="異常"
fi

if [ $server = $ymlserver ];then
trueserver="相同"
else
trueserver="異常"
fi

if [ $services = $ymlservices ];then
trueservices="相同"
else
trueservices="異常"
fi

if [ $smarttalk = $ymlsmarttalk ];then
truesmarttalk="相同"
else
truesmarttalk="異常"
fi

if [ $task = $ymltask ];then
truetask="相同"
else
truetask="異常"
fi

if [ $user = $ymluser ];then
trueuser="相同"
else
trueuser="異常"
fi

if [ $webdownload = $ymlwebdownload ];then
truewebdownload="相同"
else
truewebdownload="異常"
fi

if [ $website = $ymlwebsite ];then
truewebsite="相同"
else
truewebsite="異常"
fi

if [ $websmarttalk = $ymlwebsmarttalk ];then
truewebsmarttalk="相同"
else
truewebsmarttalk="異常"
fi

echo -e "\033[34m ______________________________________________________________________________________\033[0m "
echo -e "\033[34m|    服   務     | |\033[0m ""\033[34m  Y M L 版 號   | |    運行版號     | | 運行主機 | |  image比對   |\033[0m "
echo -e "\033[34m|________________|_|_________________|_|_________________|_|__________|_|______________|\033[0m "
echo -e "\033[36m| admin         \033[0m ""\033[32m| |\033[0m ""\033[28m $admin  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymladmin  \033[0m ""\033[32m| |\033[0m ""\033[28m $mladmin  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueadmin \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| api           \033[0m ""\033[32m| |\033[0m ""\033[28m $api  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlapi  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlapi  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueapi \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| chatbot       \033[0m ""\033[32m| |\033[0m ""\033[28m $chatbot  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlchatbot  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlchatbot  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truechatbot \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| file          \033[0m ""\033[32m| |\033[0m ""\033[28m $file  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlfile  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlfile  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truefile \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| gateway       \033[0m ""\033[32m| |\033[0m ""\033[28m $gateway  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlgateway  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlgateway  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truegateway \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| push          \033[0m ""\033[32m| |\033[0m ""\033[28m $push  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlpush  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlpush  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truepush \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| robot         \033[0m ""\033[32m| |\033[0m ""\033[28m $robot  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlrobot  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlrobot  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truerobot \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| server        \033[0m ""\033[32m| |\033[0m ""\033[28m $server  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlserver  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlserver  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueserver \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| services      \033[0m ""\033[32m| |\033[0m ""\033[28m $services  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlservices  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlservices  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueservices \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| smarttalk     \033[0m ""\033[32m| |\033[0m ""\033[28m $smarttalk  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlsmarttalk  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlsmarttalk  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truesmarttalk \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| task          \033[0m ""\033[32m| |\033[0m ""\033[28m $task  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymltask  \033[0m ""\033[32m| |\033[0m ""\033[28m $mltask  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truetask \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| user          \033[0m ""\033[32m| |\033[0m ""\033[28m $user  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymluser  \033[0m ""\033[32m| |\033[0m ""\033[28m $mluser  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueuser \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| web-download  \033[0m ""\033[32m| |\033[0m ""\033[28m $webdownload  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlwebdownload  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlwebdownload  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truewebdownload \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| website       \033[0m ""\033[32m| |\033[0m ""\033[28m $website  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlwebsite  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlwebsite  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truewebsite \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| web-smarttalk \033[0m ""\033[32m| |\033[0m ""\033[28m $websmarttalk  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlwebsmarttalk  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlwebsmarttalk  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truewebsmarttalk \033[0m ""\033[36m    |\033[0m "
echo -e "\033[34m|________________|_|_________________|_|_________________|_|__________|_|______________|\033[0m "


