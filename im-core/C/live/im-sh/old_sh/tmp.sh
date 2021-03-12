#!/bin/sh
echo -e "\033[33m IM 服務(image)更新腳本\033[0m"
echo -e "\033[36m * 靜態資源 * \033[0m"
echo -e "\033[32m admin file web-download website web-smarttalk \033[0m"
echo -e "\033[36m * 動態資源 * \033[0m"
echo -e "\033[32m api chatbot file gateway push robot server services smarttalk task user  \033[0m"
echo -e "\033[36m * 開始部署 * \033[0m"
read -p "請輸入要部署的遊戲名稱:  "  servicename



#site 分類
#web-download services gateway website
if [ $servicename = web-download ] || [ $servicename = services ] || [ $servicename = gateway ] || [ $servicename = website ] ;then
/bin/ssh -p 6343 op@im-site-001 rectn site rm -rf /tmp/proxy-cache/*
#/bin/ssh -p 6343 op@im-site-002 rectn site rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"

#admin 分類
#admin task web-smarttalk
elif  [ $servicename = web-smarttalk  ]  ;then
/bin/ssh -p 6343 op@im-adm-001 rectn adm  rm -rf /tmp/proxy-cache/*
#/bin/ssh -p 6343 op@im-adm-002 rectn adm  rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"
echo -e "\033[32m * 開始清綜防緩存 * \033[0m"
#!/bin/sh
timestamp=`date +%s`
sign=$(echo -n "458ffcf21542e85d9849034253c1e6c6${timestamp}"|md5sum|cut -d ' ' -f1 )
getkey=$(curl -H "Content-Type:application/json" -X POST -d '{"sign":"'${sign}'","time":"'${timestamp}'","uid":100002,"vhost":"i02-site-049"}' 'https://panel.cdn-ng.cc:8443/api/user/login/token')
token=${getkey:50:32}
curl -H "Content-Type:application/json" -b "JSESSIONID=${token}" -X POST -d '{"hard":0}' 'https://panel.cdn-ng.cc:8443/api/site/i02-site-049/setting/cacheflushtime'
echo -e "\033[32m * 清綜防緩存成功 * \033[0m"


elif [ $servicename = admin ] || [ $servicename = task ] ;then
/bin/ssh -p 6343 op@im-adm-001 rectn adm  rm -rf /tmp/proxy-cache/*
#/bin/ssh -p 6343 op@im-adm-002 rectn adm  rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"

#api 分類
#api file  robot  smarttalk
elif [ $servicename = api ] || [ $servicename = file ] || [ $servicename = robot ] || [ $servicename = smarttalk ] ;then
/bin/ssh -p 6343 op@im-api-001 rectn api  rm -rf /tmp/proxy-cache/*
#/bin/ssh -p 6343 op@im-api-002 rectn api  rm -rf /tmp/proxy-cache/*
echo -e "\033[32m * 清外圍Cache成功 * \033[0m"

else
echo -e "\033[37m * 清除cache 失敗!! * \033[0m"
fi


