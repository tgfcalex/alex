#!/bin/bash
#抓取容器名稱ip
#sm_rd-1
smrd1=`/usr/bin/ssh   root@im-b1 docker ps -a | grep sm_rd-1 | awk '{print $NF}'`
smiprd1=`/usr/bin/ssh   root@im-b1 rectn $smrd1 ip a | grep 10.100. | awk -F '/' '{print $1}' | awk '{print $2}' `
#echo $smiprd1 > /var/env/im/live/deploy/middleware/smsmrd1.txt
#sm_rd-6
smrd6=`/usr/bin/ssh   root@im-b3 docker ps -a | grep sm_rd-6 | awk '{print $NF}'`
smiprd6=`/usr/bin/ssh   root@im-b3 rectn $smrd6 ip a | grep 10.100. | awk -F '/' '{print $1}' | awk '{print $2}' `
#echo $smiprd6 > /var/env/im/live/deploy/middleware/smsmrd6.txt
#sm_rd-2
smrd2=`/usr/bin/ssh   root@im-b2 docker ps -a | grep sm_rd-2 | awk '{print $NF}'`
smiprd2=`/usr/bin/ssh   root@im-b2 rectn $smrd2 ip a | grep 10.100. | awk -F '/' '{print $1}' | awk '{print $2}' `
#echo $smiprd2 > /var/env/im/live/deploy/middleware/smsmrd2.txt
#sm_rd-5
smrd5=`/usr/bin/ssh   root@im-b2 docker ps -a | grep sm_rd-5 | awk '{print $NF}'`
smiprd5=`/usr/bin/ssh   root@im-b2 rectn $smrd5 ip a | grep 10.100. | awk -F '/' '{print $1}' | awk '{print $2}' `
#echo $smiprd5 > /var/env/im/live/deploy/middleware/smsmrd5.txt
#sm_rd-3
smrd3=`/usr/bin/ssh   root@im-b3 docker ps -a | grep sm_rd-3 | awk '{print $NF}'`
smiprd3=`/usr/bin/ssh  root@im-b3 rectn $smrd3 ip a | grep 10.100. | awk -F '/' '{print $1}' | awk '{print $2}' `
#echo $smiprd3 > /var/env/im/live/deploy/middleware/smsmrd3.txt
#sm_rd-4
smrd4=`/usr/bin/ssh   root@im-b1 docker ps -a | grep sm_rd-4 | awk '{print $NF}'`
smiprd4=`/usr/bin/ssh   root@im-b1 rectn $smrd4 ip a | grep 10.100. | awk -F '/' '{print $1}' | awk '{print $2}' `
#echo $smiprd4 > /var/env/im/live/deploy/middleware/smsmrd4.txt
#echo $smrd1
echo rd1 = $smiprd1
echo rd2 = $smiprd2
echo rd3 = $smiprd3
echo rd4 = $smiprd4
echo rd5 = $smiprd5
echo rd6 = $smiprd6

echo -e  "輸入自動加集群指令"
echo redis-trib.rb create --replicas 1 $smiprd1:6379 $smiprd2:6379 $smiprd3:6379 $smiprd4:6379 $smiprd5:6379 $smiprd6:6379 
