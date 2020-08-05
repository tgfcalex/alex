#dubbo版本号(请注意此变量勿删除，00脚本调用)
dubbo_version="010107"
# 控制机工程目录
base_path='/var/env'
# 实际应用目录
dist_base_path='/var/lb'
# 平台
project="v-lb"
# 完整包的源路径
latest_app_dir="${base_path}/apps/lb/work"
v_dist_app_dir="/var/v-lb/apps"

#服务和应用的区分
#应用
options_apply="
    mdcenter
    manager
    api
    hall
"
#服务
options_service="
    server
    schedule
    game-schedule
    cache-service
"
#tomcat包
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
#静态资源
RSPKG="
    fserver
    mobile-h5
    pc-h5
    rcenter
"
#pay支付jar包
pay_impl_jars="pay-impl-jars"

RS="
    lr1
    lr2
    "
AS="
    la1
    "
# ------------------ 全线发包脚本，此处定义全app应用 -------------------------
options_srv="$ALLPKG"

options_all="$options_srv"
username="root"
port="22"
#port="6343"


