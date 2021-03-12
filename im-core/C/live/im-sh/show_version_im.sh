#!/bin/sh

# yml路徑
path="/var/env/im/live/deploy/yml"
#運行服務清單(每次執行產出)
txtRunningServicePath=im_Running_service
#hub路徑
huburl=hub.chats-boss.com/im
#匯出運行的服務清單
#echo -e "\033[32m * 清空im服務清單 * \033[0m "
#sleep 1
echo "" > ./$txtRunningServicePath/Running.txt
#echo -e "\033[32m * 產出im服務清單 * \033[0m "
docker stack ps im | grep Running >> ./$txtRunningServicePath/Running.txt
#sleep 2

# 取yml內image版本
api=`cat $path/api.yml | grep hub.chats-boss.com/im/* | awk -F ':' '{print $3}'`
admin=`cat $path/admin.yml | grep hub.chats-boss.com/im/* | awk -F ':' '{print $3}'`
chatbot=`cat $path/chatbot.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
file=`cat $path/file.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
gateway=`cat $path/gateway.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
push=`cat $path/push.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
robot=`cat $path/robot.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
server=`cat $path/server.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
services=`cat $path/services.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
smarttalk=`cat $path/smarttalk.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
task=`cat $path/task.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
user=`cat $path/user.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
webdownload=`cat $path/web-download.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
website=`cat $path/website.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
websmarttalk=`cat $path/web-smarttalk.yml | grep hub.chats-boss.com/im/* | awk '{print $2}' | awk -F ':' '{print $2}'`
# 取運行中服務的image版號-1
ymladmin=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_admin |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlchatbot=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_chatbot |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymltask=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_task |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlwebdownload=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_web_download |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlwebsite=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_jm_website |  awk -F ':' '{print $2}'  | awk '{print $1}'`
ymlwebsmarttalk=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_web_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $1}'`
# 取運行中服務的機器位置-1
mladmin=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_admin |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlchatbot=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_chatbot |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mltask=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_task |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlwebdownload=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_web_download |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlwebsite=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_jm_website |  awk -F ':' '{print $2}'  | awk '{print $2}'`
mlwebsmarttalk=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_web_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $2}'`

# 單服務比對
if [ $admin = $ymladmin ];then
trueadmin="相 同"
else
trueadmin="*異常"
fi

if [ $chatbot = $ymlchatbot ];then
truechatbot="相 同"
else
truechatbot="*異常"
fi

if [ $task = $ymltask ];then
truetask="相 同"
else
truetask="*異常"
fi

if [ $webdownload = $ymlwebdownload ];then
truewebdownload="相 同"
else
truewebdownload="*異常"
fi

if [ $website = $ymlwebsite ];then
truewebsite="相 同"
else
truewebsite="*異常"
fi

if [ $websmarttalk = $ymlwebsmarttalk ];then
truewebsmarttalk="相 同"
else
truewebsmarttalk="*異常"
fi



# 取運行中服務的image版號-2
ymlapi01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_api |  awk -F ':' '{print $2}'  | awk '{print $1}' | awk 'NR==1{print}'`
ymlapi02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_api |  awk -F ':' '{print $2}'  | awk '{print $1}' | awk 'NR==2{print}'`
ymlfile01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_file |  awk -F ':' '{print $2}'  | awk '{print $1}' | awk 'NR==1{print}'`
ymlfile02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_file |  awk -F ':' '{print $2}'  | awk '{print $1}' | awk 'NR==2{print}'`
ymlgateway01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_gateway |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==1{print}'`
ymlgateway02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_gateway |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==2{print}'`
ymlpush01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_push |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==1{print}'`
ymlpush02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_push |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==2{print}'`
ymlrobot01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_robot |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==1{print}'`
ymlrobot02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_robot |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==2{print}'`
ymlserver01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_server |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==1{print}'`
ymlserver02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_server |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==2{print}'`
ymlservices01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_services |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==1{print}'`
ymlservices02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_services |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==2{print}'`
ymlsmarttalk01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==1{print}'`
ymlsmarttalk02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==2{print}'`
ymluser01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_user |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==1{print}'`
ymluser02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_user |  awk -F ':' '{print $2}'  | awk '{print $1}'| awk 'NR==2{print}'`
# 取運行中服務的機器位置-2
mlapi01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_api |  awk -F ':' '{print $2}'  | awk '{print $2}' | awk 'NR==1{print}'` 
mlapi02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_api |  awk -F ':' '{print $2}'  | awk '{print $2}' | awk 'NR==2{print}'`
mlfile01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_file |  awk -F ':' '{print $2}'  | awk '{print $2}' | awk 'NR==1{print}'`
mlfile02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_file |  awk -F ':' '{print $2}'  | awk '{print $2}' | awk 'NR==2{print}'`
mlgateway01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_gateway |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==1{print}'`
mlgateway02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_gateway |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==2{print}'`
mlpush01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_push |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==1{print}'`
mlpush02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_push |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==2{print}'`
mlrobot01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_robot |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==1{print}'`
mlrobot02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_robot |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==2{print}'`
mlserver01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_server |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==1{print}'`
mlserver02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_server |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==2{print}'`
mlservices01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_services |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==1{print}'`
mlservices02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_services |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==2{print}'`
mlsmarttalk01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==1{print}'`
mlsmarttalk02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_smarttalk |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==2{print}'`
mluser01=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_user |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==1{print}'`
mluser02=`cat ./$txtRunningServicePath/Running.txt | grep $huburl/im_user |  awk -F ':' '{print $2}'  | awk '{print $2}'| awk 'NR==2{print}'`
if [ $api = $ymlapi01 ];then
trueapi01="相 同"
else
trueapi01="*異常"
fi
if [ $api = $ymlapi02 ];then
trueapi02="相 同"
else
trueapi02="*異常"
fi
if [ $file = $ymlfile01 ];then
truefile01="相 同"
else
truefile01="*異常"
fi
if [ $file = $ymlfile02 ];then
truefile02="相 同"
else
truefile02="*異常"
fi
if [ $gateway = $ymlgateway01 ];then
truegateway01="相 同"
else
truegateway01="*異常"
fi
if [ $gateway = $ymlgateway02 ];then
truegateway02="相 同"
else
truegateway02="*異常"
fi
if [ $push = $ymlpush01 ];then
truepush01="相 同"
else
truepush01="*異常"
fi
if [ $push = $ymlpush02 ];then
truepush02="相 同"
else
truepush02="*異常"
fi
if [ $robot = $ymlrobot01 ];then
truerobot01="相 同"
else
truerobot01="*異常"
fi
if [ $robot = $ymlrobot02 ];then
truerobot02="相 同"
else
truerobot02="*異常"
fi
if [ $server = $ymlserver01 ];then
trueserver01="相 同"
else
trueserver01="*異常"
fi
if [ $server = $ymlserver02 ];then
trueserver02="相 同"
else
trueserver02="*異常"
fi
if [ $services = $ymlservices01 ];then
trueservices01="相 同"
else
trueservices01="*異常"
fi
if [ $services = $ymlservices02 ];then
trueservices02="相 同"
else
trueservices02="*異常"
fi
if [ $smarttalk = $ymlsmarttalk01 ];then
truesmarttalk01="相 同"
else
truesmarttalk01="*異常"
fi
if [ $smarttalk = $ymlsmarttalk02 ];then
truesmarttalk02="相 同"
else
truesmarttalk02="*異常"
fi
if [ $user = $ymluser01 ];then
trueuser01="相 同"
else
trueuser01="*異常"
fi
if [ $user = $ymluser02 ];then
trueuser02="相 同"
else
trueuser02="*異常"
fi
echo -e "\033[34m _______________________________________________________________________________________ \033[0m "
echo -e "\033[34m|                | |                 | |                 | |          | |               |\033[0m "
echo -e "\033[34m|    服   務     | |   Y M L 版 號   | |    運行版號     | | 運行主機 | |  image比對    |\033[0m "
echo -e "\033[34m|________________|_|_________________|_|_________________|_|__________|_|_______________|\033[0m "
echo -e "\033[36m| admin         \033[0m ""\033[32m| |\033[0m ""\033[28m $admin  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymladmin  \033[0m ""\033[32m| |\033[0m ""\033[28m $mladmin  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueadmin \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| chatbot       \033[0m ""\033[32m| |\033[0m ""\033[28m $chatbot \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlchatbot \033[0m ""\033[32m| |\033[0m ""\033[28m $mlchatbot  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truechatbot \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| task          \033[0m ""\033[32m| |\033[0m ""\033[28m $task  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymltask  \033[0m ""\033[32m| |\033[0m ""\033[28m $mltask  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truetask \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| web-download  \033[0m ""\033[32m| |\033[0m ""\033[28m $webdownload  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlwebdownload  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlwebdownload  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truewebdownload \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| website       \033[0m ""\033[32m| |\033[0m ""\033[28m $website  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlwebsite  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlwebsite  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truewebsite \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| web-smarttalk \033[0m ""\033[32m| |\033[0m ""\033[28m $websmarttalk \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlwebsmarttalk \033[0m ""\033[32m| |\033[0m ""\033[28m $mlwebsmarttalk  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truewebsmarttalk \033[0m ""\033[36m    |\033[0m "
echo -e "\033[34m|________________|_|_________________|_|_________________|_|__________|_|_______________|\033[0m "
echo -e "\033[36m| api-01        \033[0m ""\033[32m| |\033[0m ""\033[28m $api  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlapi01  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlapi01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueapi01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| api-02        \033[0m ""\033[32m| |\033[0m ""\033[28m $api  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlapi02  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlapi02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueapi02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| file-01       \033[0m ""\033[32m| |\033[0m ""\033[28m $file  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlfile01  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlfile01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truefile01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| file-02       \033[0m ""\033[32m| |\033[0m ""\033[28m $file  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlfile02  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlfile02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truefile02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| gateway-01    \033[0m ""\033[32m| |\033[0m ""\033[28m $gateway  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlgateway01  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlgateway01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truegateway01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| gateway-02    \033[0m ""\033[32m| |\033[0m ""\033[28m $gateway  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlgateway02  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlgateway02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truegateway02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| push-01       \033[0m ""\033[32m| |\033[0m ""\033[28m $push  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlpush01  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlpush01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truepush01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| push-02       \033[0m ""\033[32m| |\033[0m ""\033[28m $push  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlpush02  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlpush02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truepush02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| robot-01      \033[0m ""\033[32m| |\033[0m ""\033[28m $robot  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlrobot01  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlrobot01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truerobot01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| robot-02      \033[0m ""\033[32m| |\033[0m ""\033[28m $robot  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlrobot02  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlrobot02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truerobot02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| server-01     \033[0m ""\033[32m| |\033[0m ""\033[28m $server  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlserver01  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlserver01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueserver01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| server-02     \033[0m ""\033[32m| |\033[0m ""\033[28m $server  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlserver02  \033[0m ""\033[32m| |\033[0m ""\033[28m $mlserver02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueserver02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| services-01   \033[0m ""\033[32m| |\033[0m ""\033[28m $services \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlservices01 \033[0m ""\033[32m| |\033[0m ""\033[28m $mlservices01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueservices01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| services-02   \033[0m ""\033[32m| |\033[0m ""\033[28m $services \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlservices02 \033[0m ""\033[32m| |\033[0m ""\033[28m $mlservices02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueservices02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| smarttalk-01  \033[0m ""\033[32m| |\033[0m ""\033[28m $smarttalk \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlsmarttalk01 \033[0m ""\033[32m| |\033[0m ""\033[28m $mlsmarttalk01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truesmarttalk01 \033[0m ""\033[36m    |\033[0m"
echo -e "\033[36m| smarttalk-02  \033[0m ""\033[32m| |\033[0m ""\033[28m $smarttalk \033[0m ""\033[32m| |\033[0m ""\033[28m $ymlsmarttalk02 \033[0m ""\033[32m| |\033[0m ""\033[28m $mlsmarttalk02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $truesmarttalk02 \033[0m ""\033[36m    |\033[0m"
echo -e "\033[36m| user-01       \033[0m ""\033[32m| |\033[0m ""\033[28m $user  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymluser01  \033[0m ""\033[32m| |\033[0m ""\033[28m $mluser01  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueuser01 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[36m| user-02       \033[0m ""\033[32m| |\033[0m ""\033[28m $user  \033[0m ""\033[32m| |\033[0m ""\033[28m $ymluser02  \033[0m ""\033[32m| |\033[0m ""\033[28m $mluser02  \033[0m ""\033[32m| |\033[0m ""\033[28m   $trueuser02 \033[0m ""\033[36m    |\033[0m "
echo -e "\033[34m|________________|_|_________________|_|_________________|_|__________|_|_______________|\033[0m "
