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

#admin 分類
#admin task web-smarttalk
elif  [ $servicename = web-smarttalk  ]  ;then
/bin/ssh -p 6343 op@im-adm-001 rectn adm  rm -rf /tmp/proxy-cache/*
#/bin/ssh -p 6343 op@im-adm-002 rectn adm  rm -rf /tmp/proxy-cache/*
echo echo -e "\033[32m * 更新web-smarttalk,請手動清除重防crm服務cache * \033[0m"

elif [ $servicename = admin ] || [ $servicename = task ] ;then
/bin/ssh -p 6343 op@im-adm-001 rectn adm  rm -rf /tmp/proxy-cache/*
#/bin/ssh -p 6343 op@im-adm-002 rectn adm  rm -rf /tmp/proxy-cache/*

#api 分類
#api file  robot  smarttalk
elif [ $servicename = api ] || [ $servicename = file ] || [ $servicename = robot ] || [ $servicename = smarttalk ] ;then
/bin/ssh -p 6343 op@im-api-001 rectn api  rm -rf /tmp/proxy-cache/*
#/bin/ssh -p 6343 op@im-api-002 rectn api  rm -rf /tmp/proxy-cache/*

else
echo -e "\033[37m * 清除cache 失敗!! * \033[0m"
fi


