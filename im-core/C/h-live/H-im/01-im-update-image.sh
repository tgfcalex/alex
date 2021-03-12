#!/bin/sh
# Author: Hunter
# Date : 20200422
echo -e "\033[33m IM 灰度線 服務(image)更新腳本 v1.0.1 \033[0m"
echo -e "\033[36m * 靜態資源 * \033[0m"
echo -e "\033[32m admin file web-download website web-smarttalk sm_website\033[0m"
echo -e "\033[36m * 動態資源 * \033[0m"
echo -e "\033[32m api chatbot file gateway push robot server services smarttalk task user  \033[0m"
echo -e "\033[36m * 開始部署 * \033[0m"
read -p " * 請輸入要部署的遊戲名稱:  "  servicename

#單服務
if [ $servicename == sm_website ]||[ $servicename == api ]||[ $servicename == website ]||[ $servicename == file ]||[ $servicename == gateway ]||[ $servicename == push ]||[ $servicename == robot ]||[ $servicename == server ]||[ $servicename == services ]||[ $servicename == smarttalk ]||[ $servicename == user ]||[ $servicename == admin ]||[ $servicename == chatbot ]||[ $servicename == task ]||[ $servicename == web-download ]||[ $servicename == web-smarttalk  ]; then
    source /root/im-sh/H-im/update_version_im.sh
else
    echo -e "\033[34m 輸入的服務錯誤!!! \033[0m "
fi
