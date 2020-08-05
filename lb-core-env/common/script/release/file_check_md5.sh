#!/usr/bin/env bash
# __author__ == "Sun"
# Description: 中心思想
#1. 循环遍历目录和目录下的文件
#2. 去对应主机目录下，对比文件md5值是否一致
#3. 输出结果

#Usage: $0  大鱼复制上传包路径

if [ $# -ne 1 ];then
    echo -e "指定大鱼发包上传路径作为参数1"
    exit 1
elif [[ ! -d $1 ]];then
    echo -e "目录不存在"
    exit 2
fi

#定义主机组
RS="lr1  lr2"
AS="la1 la2  la3"

#la主机包
ALLPKG="api cache-service  game-schedule hall manager mdcenter schedule server pay-impl-jars"
#lr主机包
RSPKG="fserver mobile-h5 pc-h5 rcenter"

#定义远端主机信息
user="root"
app_path="/var/lb/apps"

#定义源路径
source_dir="$1"
cd $source_dir
#获取应用包名称
app_name=`ls`

#检测文件md5值是否一致
checkFile() {
    #循环主机列表，ssh命令获取远端主机指定目录下的文件md5值，做对比
    for host in $work_host;do
        printf "|---------------------------------------------------------------------------------------------------------------------------------------------------------|\n"
        printf "| %-4s | %-16s | %-104s | %-27s |\n" "主机" "应用名" "更新文件" "状态"
        printf "|---------------------------------------------------------------------------------------------------------------------------------------------------------|\n"
        ssh $user@$host md5sum  $app_path/$file &>/dev/null
        if [ $? -eq 0 ];then
            dest_file_md5=`ssh $user@$host md5sum  /var/lb/apps/$file | awk '{print $1}'`
        else
            dest_file_md5=""
            errorStatus="目标文件不存在，请手动查看"
        fi
        if [[ -n $dest_file_md5 ]];then
            if [[ $source_file_md5 == $dest_file_md5 ]];then
                status="一致"
                printf  "| %-4s | %-13s | %-100s |" "$host" "$app" "$file"
                printf "\033[32m %-27s | \033[m\n" $status
                printf "|---------------------------------------------------------------------------------------------------------------------------------------------------------|\n"
            elif [[ $source_file_md5 != $dest_file_md5 ]];then
                status="不一致，请手动查看"
                printf  "| %-4s | %-13s | %-100s | " "$host" "$app" "$file"
                printf "\033[31m %-33s |\033[m \n" "$status"
                printf "|---------------------------------------------------------------------------------------------------------------------------------------------------------|\n"
            fi
        else
            printf  "| %-4s | %-13s | %-100s |" "$host" "$app" "$file"
            printf "\033[31m %-33s |\033[m \n" "$errorStatus"
            printf "|---------------------------------------------------------------------------------------------------------------------------------------------------------|\n"
        fi
    done
}
#循环获取app应用名
for app in $app_name;do
    find_file=`find $app -type f`
    #app目录下循环获取文件
    for file in $find_file;do
        source_file_md5=`md5sum  $file | awk '{print $1}'`
        #判断app应用名存在的主机组
        if  echo $ALLPKG | grep -wo $app &>/dev/null;then
            work_host="$AS"
            checkFile
        elif  echo $RSPKG | grep -wo $app &>/dev/null;then
            work_host="$RS"
            checkFile
        else
            echo -e "检查应用包是否正确"
            exit 3
        fi
    done
done
