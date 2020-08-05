#!/bin/bash
ALLPKG="
    api
    cache-service
    game-schedule
    hall
    manager
    mdcenter
    schedule
    server
"
RSPKG="
    fserver
    mobile-h5
    pc-h5
    rcenter
    api-h5
    web
"

####保留最后5个包
function delete_file(){
    num=5
    filenum=$(ls -l $dir | wc -l)
    echo $filenum
    if [ $filenum -gt $num ]
        then
            oldfile=$(ls -rt $dir|head -1)
            echo "delete file:" $oldfile
            rm -rf $dir/$oldfile
    fi
}

#备份源目录
tomcat_dir=/var/env/apps/bak_apps/la3
static_dir=/var/lb/glusterfs/apps
#备份目录
full_bak=/var/bak/app/full
tomcactinc_bak=/var/bak/app/inc/tomcat
staticinc_bak=/var/bak/app/inc/static
date=`date "+%Y-%m-%d-%H-%M"`

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
echo "发包脚本执行后,执行此备份脚本
      01脚本执行后，请执行./backup.sh
      03/04脚本执行后，请执行./backup.sh lr1/la3"      
fi


# 此处的值，取决于脚本，
#host=$1               # 如果此脚本加入发包脚本，一定要屏蔽此命令

# 全库备份（发全量包时）
if [ ! $host  ] 
    then
        dir=$full_bak
        delete_file
        echo '------------全库全量备份--------------'
        echo  "------------备份时间:" $date
        mkdir -p   $full_bak/$date
        echo "备份rcenter"
        echo -e "\033[32m     " rsync -avz $static_dir/rcenter/  $full_bak/$date/rcenter/  "\033[0m"
        rsync -avz $static_dir/rcenter/  $full_bak/$date/rcenter/  >/dev/null

    for i in $ALLPKG
        do
            echo '备份'$i
            echo -e "\033[32m     " rsync -avz $tomcat_dir/$i/  $full_bak/$date/$i/ --delete=yes  "\033[0m"
            rsync -avz $tomcat_dir/$i/  $full_bak/$date/$i/ --delete=yes >/dev/null
        done
fi

#只需备份la3 和lr1 的包即可
if [ "$host" == "la3" ]
    then
        dir=$tomcactinc_bak
        delete_file
        mkdir -p   $tomcactinc_bak/$date
    for i in $ALLPKG
        do
            echo "备份"$i
            echo -e "\033[32m     " rsync -avz $tomcat_dir/$i/  $tomcactinc_bak/$date/$i/ --delete=yes  "\033[0m" 
            rsync -avz $tomcat_dir/$i/  $tomcactinc_bak/$date/$i/ --delete=yes >/dev/null
        done
fi


if [ "$host" == "lr1" ]
    then
        dir=$staticinc_bak
        delete_file
        mkdir -p   $staticinc_bak/$date
    for i in $RSPKG
        do
            echo "备份"$i
            echo -e "\033[32m     " rsync -avz $static_dir/$i/  $staticinc_bak/$date/$i/ --delete=yes "\033[0m"
            rsync -avz $static_dir/$i/  $staticinc_bak/$date/$i/ --delete=yes >/dev/null
        done
fi

