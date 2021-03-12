#!/bin/sh
# Author: Hunter
# Date : 20200422
echo -e "\033[33m IM 生產線 服務(image)更新腳本 v1.0.1 \033[0m"
echo -e "\033[36m * 靜態資源 * \033[0m"
echo -e "\033[32m admin file web-download website web-smarttalk sm_website\033[0m"
echo -e "\033[36m * 動態資源 * \033[0m"
echo -e "\033[32m api chatbot file gateway push robot server services smarttalk task user  \033[0m"
echo -e "\033[36m * 開始部署 * \033[0m"
read -p " * 請輸入要部署的遊戲名稱:  "  servicename

#雙服務
if [ $servicename == api ]||[ $servicename == file ]||[ $servicename == gateway ]||[ $servicename == push ]||[ $servicename == robot ]||[ $servicename == server ]||[ $servicename == services ]||[ $servicename == smarttalk ]||[ $servicename == user ]; then
    source /root/im-sh/update_version_im_2.sh
#單服務
elif [ $servicename == admin ]||[ $servicename == chatbot ]||[ $servicename == task ]||[ $servicename == web-download ]||[ $servicename == website ]||[ $servicename == web-smarttalk  ]||[ $servicename == sm_website  ];then
    source /root/im-sh/update_version_im.sh
else
    echo -e "\033[34m 輸入的服務錯誤!!! \033[0m "
fi
