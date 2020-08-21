#dubbo版本号(请注意此变量勿删除，00脚本调用)
dubbo_version=093014
# 共用脚本目录
exp_script_dir='/var/env/common/script/v-release/'
# 控制机工程目录
base_path='/var/env'
# 实际应用目录
dist_base_path='/var/lb'
# 平台
project="lb"
# 完整包的源路径
latest_app_dir="${base_path}/v-apps/${project}/work"
dist_app_dir="/var/v-lb/apps"
bak_app_dir="/var/v-lb/apps/bak_apps"
apps_path="$base_path/v-apps/$project"
# 静态资源分布式文件系统挂载目录
#distributed_dir="/var/lb/glusterfs/apps"

#服务和应用的区分
#应用
options_apply="
    mdcenter
    manager
    api
    hall
    merchant-api
    distributor-api
"
#服务
options_service="
    server
    cache-service
"
#tomcat包
ALLPKG="
    api
    cache-service
    hall
    manager
    mdcenter
    server
    merchant-api
    distributor-api
"
#静态资源
RSPKG="
    api-h5
    fserver
    mobile-h5
    pc-h5
    rcenter
    web
    merchant-api-web
    distributor-api-web
"
#pay支付jar包
pay_impl_jars="pay-impl-jars"

RS="
    lr1
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



# ----------------------------------------------------- 替换配置 for conf.sh
# fserver
filesite_url='http://v-lb-fserver:80/fserver'
file_upload_tmp='/data/upload/tmp'
file_upload_data='/data/upload/data'

# duboo
zookeeper_url='zk_zook-1:2181,zk_zook-2:2181,zk_zook-3:2181,zk_zook-4:2181,zk_zook-5:2181,zk_zook-6:2181'

# ----------------2018 05-31 redis config ----------------
# redis 非集群配置
data_redis_host=''
pageCache_redis_host=''
shiro_session_host=''
shiro_auth_host=''
gameApi_redis_host=''
gather_redis_host=''
api_token_host=''
# redis 集群配置
data_cluster='dt_rd-1:6379,dt_rd-2:6379,dt_rd-3:6379,dt_rd-4:6379,dt_rd-5:6379,dt_rd-6:6379'
common_cluster='ss_rd-1:6379,ss_rd-2:6379,ss_rd-3:6379,ss_rd-4:6379,ss_rd-5:6379,ss_rd-6:6379'
# ----- data cluster -----
data_redis_hosts="$data_cluster"
pageCache_redis_hosts="$data_cluster"
gameApi_redis_hosts="$data_cluster"
gather_redis_hosts="$data_cluster"
api_token_hosts="$data_cluster"
# ----- session cluster -----
shiro_session_hosts="$common_cluster"
shiro_auth_hosts="$common_cluster"

# web
dubbo_port='30001'
dubbo_provider_delay='30000'
website_uri='{site.context.path}'
ressite_uri='/rcenter${site.res}'
comressite_uri='/rcenter/common'
imgsite_uri='/fserver'
mdsite_uri='{site.context.path}/mdcenter/${mdsite.comet}.comet'
mdsite_ip='lb_mdcenter'
freemaker_template_root_path=http://v-lb-fserver:80/ftl/

# --------------- postgresql
password_decrypt='true'

# boss
bossDataSource_url='jdbc:postgresql://pg-01.ld1:5501/lb-boss?characterEncoding=UTF-8\&ApplicationName=\${product.code}-\${dubbo.application.name}'
bossDataSource_username='lb-manager'
#bossDataSource_password='j8/rGKDB+w/xpDSKU1fZenX0TDv9fC6bsMW43I5xDV0ommMhxZVntApLKhga1xb2wUpLnFOVp7lNnro/iPVOvw=='
#数据库密码更改-2018.11.8
bossDataSource_password='Kr2znKEkKkLjiVQPtcVtREr4ufCrjh2W68wnywz36VUTjqwSyE0o+kRg16bcBlvm3T5zjV4obWs83QtEKvsV6g=='

## companies
#mainsiteDataSource_url='jdbc:postgresql://pg-mx.d7:5407/gb-companies?characterEncoding=UTF-8'
#mainsiteDataSource_username='gb-companies'
#mainsiteDataSource_password='FejXJM95G9u/j2fD5z22yZLk66ynz+nm3y5TLSX9uhKMnyirOzMTf2f2aqN4GTFBYVbA0CLneiEpkTWn4kJT9g=='
#
## stat
#statDataSource_url='jdbc:postgresql://pg-mx.d7:5407/gb-stat?characterEncoding=UTF-8'
#statDataSource_username='gb-stat'
#statDataSource_password='X1xkkQQoboVPlp37LLDJ66GeR1krgGb7ySOG+iYzNhTSj2ma/8PPm/EhdWEoagA9Iek0kC+BgBJWoK/XQ6QKAA=='
#
## apiLog
#apiLogDataSource_url='jdbc:postgresql://pg-mx.d7:5407/gb-companies?characterEncoding=UTF-8'
#apiLogDataSource_username='gb-companies'
#apiLogDataSource_password='FejXJM95G9u/j2fD5z22yZLk66ynz+nm3y5TLSX9uhKMnyirOzMTf2f2aqN4GTFBYVbA0CLneiEpkTWn4kJT9g=='
#
## history
#historyDataSource_url='jdbc:postgresql://pg-mx.d7:5407/gamebox-history?characterEncoding=UTF-8'
#historyDataSource_username='postgres'
#historyDataSource_password='postgresqltest'
#
## backup
#backupDataSource_url='jdbc:postgresql://pg-mx.d7:5407/gamebox-backup?characterEncoding=UTF-8'
#backupDataSource_username='postgres'
#backupDataSource_password='postgresqltest'

# rocketmq
rocketMQ_namesrvAddr='mq_node1-m:9876;mq_node2-m:9876;mq_node3-m:9876;mq_node1-s:9876;mq_node2-s:9876;mq_node3-s:9876'
rdb_dir='/var/data/mq/rdb'

# gather
gather_version='1.0'
#gather_zookeeper_url_client='60.199.195.2:92,60.199.195.145:92'
#gather_zookeeper_url_server='zk_zook-1:2181,zk_zook-2:2181,zk_zook-3:2181,zk_zook-4:2181,zk_zook-5:2181,zk_zook-6:2181,'
#gather_zookeeper_node_nginx='60.199.195.2:61 60.199.195.2:62 60.199.195.2:63 60.199.195.145:61 60.199.195.145:62 60.199.195.145:63'

# api
gather_zookeeper_node_prefix='inner'

#IDC归属地
belong_idc='V'
