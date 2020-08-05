# 注意下面的路径有 2处需要修改，而且如果是后台全量包，一定要回滚rcenter
# 为了意外发生，回滚之前先备份 /var/env/apps/bak_apps/ 此目录
#!/bin/bash
for pkg in cache-service mdcenter manager api hall server schedule game-schedule
do
   common="rsync -azv --delete /var/env/apps/bak_apps/la1/$pkg/  root@la1:/var/lb/apps/$pkg/"
   echo "$common"
   eval $common
done

# rcenter 回滚：
rsync -azv --delete /var/env/apps/bak_apps/lr1/rcenter/  root@lr1:/var/lb/apps/rcenter/

#其他静态资源回滚和rcenter 一样，只需修改 包名即可
