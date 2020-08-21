#!/usr/bin/env bash

cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $cur_dir/_variable.sh

rcVersion=`date "+%Y%m%d%H%M%S"`
dubbo_version=`date "+%m%d%H"`

#将此dubbo_version的变量写入_variable.sh脚本中
sed -i "2c dubbo_version=${dubbo_version}"  $cur_dir/_variable.sh


# -------------------------------------------------------- main --------------------------------------------------------
echo "
    ---------------------------------------- 1. 准备应用目录
    "
rm -rf  $apps_path/release/*
for app in $ALLPKG $RSPKG; do
    if [[ -d "$apps_path/work/$app/" ]]; then
        # 清空旧目录
        rm -rf  $apps_path/work/$app/*
    else
        mkdir -p $apps_path/work/$app/
    fi
    tree -L 1 "$apps_path/work/$app/"
done

echo "
    ---------------------------------------- 2. 重组装 app 包
    $exp_script_dir/unpackage.py $base_path $project
    "
python $exp_script_dir/unpackage.py $base_path $project


echo "
    ---------------------------------------- 3. 替换配置, 应用全量包打包到 $apps_path/release/
    "
for app in $ALLPKG; do
    WEBSITE="$apps_path/work/${app}/WEB-INF/classes/conf"
    echo "${app}:
          $exp_script_dir/conf.sh $WEBSITE $app"
    source     $exp_script_dir/conf.sh $WEBSITE $app

    # 打包到 /release/
    echo "        ( cd  $apps_path/work/$app/ && zip -rq $apps_path/release/${app}.war ./ )"
        (
                cd  $apps_path/work/$app/ && zip -rq $apps_path/release/${app}.war ./
        )
done

echo "
    ---------------------------------------- 4. 特殊资源: $RSPKG
    "
for app in $RSPKG; do
    echo "---- $app"
    # 统一把war放到 $apps_path/release/  (gb)
    if [[ -f $apps_path/packages/${app}.war ]]; then
        echo "cp $apps_path/packages/${app}.war $apps_path/release/"
              cp $apps_path/packages/${app}.war $apps_path/release/
    fi

    # 统一把war放到 $apps_path/release/   (lb)
    if [[ -f $base_path/v-apps/${project}/pkgs/wars/${app}.war ]]; then
        echo \cp -f $base_path/v-apps/${project}/pkgs/wars/${app}.war $apps_path/release/${app}.war
             \cp -f $base_path/v-apps/${project}/pkgs/wars/${app}.war $apps_path/release/${app}.war
    fi

    # 从$apps_path/release/ 解压war 到 $apps_path/work/
    if [[ -f "$apps_path/release/${app}.war" ]]; then
        # ----- 新rcenter基于dubbo version 重解压打包
        if [[ "$app" == rcenter ]]; then
            echo "mkdir -p $apps_path/work/rcenter/$dubbo_version/rcenter/"
                  mkdir -p $apps_path/work/rcenter/$dubbo_version/rcenter/
            echo "unzip -q $apps_path/release/rcenter.war -d $apps_path/work/rcenter/$dubbo_version/rcenter/"
                  unzip -q $apps_path/release/rcenter.war -d $apps_path/work/rcenter/$dubbo_version/rcenter/
        else
        # 其他war包直接解压到work/:
        echo "unzip -q $apps_path/release/${app}.war -d $apps_path/work/${app}/"
              unzip -q $apps_path/release/${app}.war -d $apps_path/work/${app}/
        fi
    fi
done

