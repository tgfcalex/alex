#!/bin/sh
#echo -e "\033[33m IM 服務(image)更新腳本\033[0m"
#echo -e "\033[36m * 靜態資源 * \033[0m"
#echo -e "\033[32m admin file web-download website web-smarttalk \033[0m"
#echo -e "\033[36m * 動態資源 * \033[0m"
#echo -e "\033[32m api chatbot file gateway push robot server services smarttalk task user  \033[0m"
#echo -e "\033[36m * 開始部署 * \033[0m"
#read -p "請輸入要部署的遊戲名稱:  "  servicename
#yml path
path="/var/env/im/h-live/h-yml"
if [ $servicename = "smarttalk"  ];then
trueservicename=1
elif [  $servicename = "web-smarttalk" ];then
trueservicename=1
elif [  $servicename = "website" ];then
trueservicename=1
#比對yml服務
else
trueservicename=`ls -l  $path/ | grep $servicename |wc -l`
fi
#服務的yml
serviceyml=$servicename.yml
#運行服務清單(每次執行產出)
txtRunningServicePath=H-im_Running_service
#hub路徑
huburl=hub.chats-boss.com/im

#判斷是否輸入正確的服務-in
if [ $trueservicename = 1 ];then
#抓取目前版號
ymlno=`cat $path/H-$serviceyml | grep hub.chats-boss.com/im/* | awk -F ':' '{print $3}'`
#匯出運行的服務清單
#echo "" > ./$txtRunningServicePath/Running.txt
#echo -e "\033[32m * 產出im服務清單 * \033[0m "
docker stack ps H | grep Running > ./$txtRunningServicePath/Running.txt
# web-smarttalk web-download website
if [ $servicename = "web-download" ]; then
    newservicename=web_download
elif [ $servicename = "web-smarttalk" ]; then
    newservicename=web_smarttalk
elif [ $servicename = "website" ]; then
    newservicename=jm_website
else
    newservicename=$servicename
fi
#取運行中服務的image版號
runningno=`cat ./$txtRunningServicePath/Running.txt | grep H_im-h-$servicename |  awk -F ':' '{print $2}'  | awk '{print $1}' `
echo  -e "\033[37m目前的 Y M L 版號 =>\033[0m" "\033[44m$newservicename:$ymlno\033[0m"
echo  -e "\033[37m目前的Running版號 =>\033[0m" "\033[42m$newservicename:$runningno\033[0m"
    #運行與yml版本號判斷-in
    if [ $newservicename:$ymlno = $newservicename:$runningno ];then
echo -e "\033[36m * 版號相同 * \033[0m"
read -p "請輸入新的服務版號 => $servicename:jm_pro_1." no
echo -e "\033[36m * Pull image * \033[0m"

trueymlno=im_$newservicename:jm_pro_1.$no
echo -e "\033[32m ==> im-a4 \033[0m "
#echo "$newservicename"
echo $trueymlno
#echo -e "root@im-a4 docker pull $huburl/$trueymlno"
/bin/ssh root@im-a4 docker pull $huburl/$trueymlno
truepullimagea1=`/bin/ssh root@im-a4 echo $?`

if [ $truepullimagea1 = 0 ];then
echo -e "\033[33m [ im-a4 ] image pull 成功!! \033[0m"
else
echo -e "\033[33m [ im-a4 ] image pull 失敗,請檢查image版號!! \033[0m"
fi
#任意鍵判斷
get_char()
{
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}
echo -e "\033[45m""\033[0m"
echo -e "\033[45m"* 請確認是否開始更新 H_im-h-$servicename,按下任意鍵繼續 !  "\033[0m"
echo -e "\033[45m""\033[0m"
echo  -e "\033[31m"結束腳本請CTRL+C "\033[0m"
char=`get_char`
    #運行與yml版本號判斷-exit
echo -e "\033[36m * Update YML image * \033[0m"
echo  -e "\033[37m目  前$servicename.yml的image指向 =>\033[0m" "\033[44m$huburl/im_$servicename:$ymlno\033[0m"
#echo -e "\033[36m * 更換YML image * \033[0m"
sed -i s/"$ymlno"/"jm_pro_1.$no"/g  $path/H-$servicename.yml
newymlno=`cat $path/H-$serviceyml | grep hub.chats-boss.com/im/* | awk -F ':' '{print $3}'`
echo  -e "\033[37m更改後$servicename.yml的image指向 =>\033[0m" "\033[42m$huburl/im_$servicename:$newymlno\033[0m"
echo -e "\033[36m * 關閉Running Service * \033[0m"
sleep 3
echo -e "\033[32m [執行關閉服務] => \033[0m" `docker service rm H_im-h-$servicename`
echo -e "\033[33m * 等待服務關閉 \033[0m"
sleep 20
echo -e "\033[36m * 移除舊的image * \033[0m"
echo -e "\033[32m ==> im-a4 \033[0m "
/bin/ssh root@im-a4 docker image rm  $huburl/im_$newservicename:$ymlno
sleep 3
echo -e "\033[36m * 開啟Running Service * \033[0m"
#判斷compose指令
if [ $servicename = web-smarttalk  ];then
    echo -e "\033[32m [執行開啟服務compose] => \033[0m" `docker stack deploy  --compose-file $path/H-$servicename.yml H `
elif [ $servicename = website ];then
    echo -e "\033[32m [執行開啟服務compose] => \033[0m" `docker stack deploy  --compose-file $path/H-$servicename.yml H `
elif [ $servicename = services ];then
    echo -e "\033[32m [執行開啟服務compose] => \033[0m" `docker stack deploy  --compose-file $path/H-$servicename.yml H `
elif [ $servicename = sm_website ];then
    echo -e "\033[32m [執行開啟服務compose] => \033[0m" `docker stack deploy  --compose-file $path/H-$servicename.yml H `
else
    echo -e "\033[32m [執行開啟服務] => \033[0m" `docker stack deploy -c $path/H-$servicename.yml H `
fi
#echo -e "\033[32m [執行開啟服務compose] => \033[0m" `docker stack deploy  --compose-file $path/$servicename.yml im `
#echo -e "\033[32m [執行開啟服務] => \033[0m" `docker stack deploy -c $path/$servicename.yml im `
sh /root/im-sh/H-im/show_version_im.sh
sleep 8


#clear cache
#site 分類
#web-download services gateway website
if [ $servicename = web-download ] || [ $servicename = services ] || [ $servicename = website ] ;then
/bin/ssh -p 6343 op@im-site-001 rectn site rm -rf /tmp/proxy-cache/*
/bin/ssh -p 6343 op@im-site-002 rectn site rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"

#admin 分類
#admin task web-smarttalk
elif  [ $servicename = web-smarttalk  ]  ;then
/bin/ssh -p 6343 op@im-adm-001 rectn adm  rm -rf /tmp/proxy-cache/*
/bin/ssh -p 6343 op@im-adm-002 rectn adm  rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"
echo -e "\033[32m * 開始清綜防緩存 * \033[0m"
#清綜防緩存
#!/bin/sh
timestamp=`date +%s`
sign=$(echo -n "458ffcf21542e85d9849034253c1e6c6${timestamp}"|md5sum|cut -d ' ' -f1 )
getkey=$(curl -H "Content-Type:application/json" -X POST -d '{"sign":"'${sign}'","time":"'${timestamp}'","uid":100002,"vhost":"i02-site-049"}' 'https://panel.cdn-ng.cc:8443/api/user/login/token')
token=${getkey:50:32}
curl -H "Content-Type:application/json" -b "JSESSIONID=${token}" -X POST -d '{"hard":0}' 'https://panel.cdn-ng.cc:8443/api/site/i02-site-049/setting/cacheflushtime'
echo -e "\033[32m * 清綜防緩存成功 * \033[0m"

elif [ $servicename = admin ] || [ $servicename = task ] ;then
/bin/ssh -p 6343 op@im-adm-001 rectn adm  rm -rf /tmp/proxy-cache/*
/bin/ssh -p 6343 op@im-adm-002 rectn adm  rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"

#api 分類
#api file  robot  smarttalk
elif [ $servicename = file ] || [ $servicename = robot ] || [ $servicename = smarttalk ] || [ $servicename = api ] || [ $servicename = gateway ]   ;then
/bin/ssh -p 6343 op@im-api-001 rectn api  rm -rf /tmp/proxy-cache/*
/bin/ssh -p 6343 op@im-api-002 rectn api  rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"

else
echo -e "\033[37m * 清除cache 失敗!! * \033[0m"
fi

    else
        echo -e "請確認運行請確認運行image版號為何與yml版號不相同！！"
    fi
else
    echo "2"
fi
