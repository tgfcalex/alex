#!/bin/bash

WEBSITE=$1
app=$2
#source /var/gb/script/$env/_variable.sh

# [base-conf.properties]
if [ -f $WEBSITE"/base-conf.properties" ]; then
    # 文件服务器地址
    sed -i 's#^filesite.uri=.*$#filesite.uri='"$filesite_url"'#' $WEBSITE/base-conf.properties
    # 机房编号
    sed -i 's#^belong.idc=.*$#belong.idc='"$belong_idc"'#' $WEBSITE/base-conf.properties
fi

# [dubbo-conf.properties]
if [ -f $WEBSITE"/dubbo-conf.properties" ]; then
    # Zookeeper的url及端口,多个用半角逗号分隔
    sed -i "s/^zookeeper.url=.*$/zookeeper.url=$zookeeper_url/" $WEBSITE/dubbo-conf.properties
    # dubbo服务版本号
    sed -i "s/^#dubbo.version=.*$/dubbo.version=$dubbo_version/" $WEBSITE/dubbo-conf.properties
    sed -i "s/^dubbo.version=.*$/dubbo.version=$dubbo_version/" $WEBSITE/dubbo-conf.properties
    sed -i "s/^dubbo.version.api=.*$/dubbo.version.api=$dubbo_version/" $WEBSITE/dubbo-conf.properties
    sed -i "s/^dubbo.provider.delay=.*$/dubbo.provider.delay=$dubbo_provider_delay/" $WEBSITE/dubbo-conf.properties
fi

#删除多余的Dubbo Version配置文件
if [ -f $WEBSITE"/dubbo-version-conf.properties" ]; then
    rm -rf $WEBSITE/dubbo-version-conf.properties
fi
if [ -f $WEBSITE"/quartz.properties" ]; then
    sed -i "s/^org.quartz.jobStore.isClustered=.*$/org.quartz.jobStore.isClustered=true/" $WEBSITE/quartz.properties
fi
if [ -f $WEBSITE"/quartz-4-api.properties" ]; then
    sed -i "s/^org.quartz.jobStore.isClustered=.*$/org.quartz.jobStore.isClustered=true/" $WEBSITE/quartz-4-api.properties
fi
if [ -f $WEBSITE"/quartz-4-once.properties" ]; then
    sed -i "s/^org.quartz.jobStore.isClustered=.*$/org.quartz.jobStore.isClustered=true/" $WEBSITE/quartz-4-once.properties
fi
if [ -f $WEBSITE"/quartz-4-lottery.properties" ]; then
    sed -i "s/^org.quartz.jobStore.isClustered=.*$/org.quartz.jobStore.isClustered=true/" $WEBSITE/quartz-4-lottery.properties
fi
if [ -f $WEBSITE"/quartz-4-site.properties" ]; then
    sed -i "s/^org.quartz.jobStore.isClustered=.*$/org.quartz.jobStore.isClustered=true/" $WEBSITE/quartz-4-site.properties
fi

# [db.properties]
if [ -f $WEBSITE"/db.properties" ]; then
    # 用户密码是否需要解密
    sed -i 's#^password.decrypt=.*$#password.decrypt='"$password_decrypt"'#' $WEBSITE/db.properties
    # Boss库连接地址
    sed -i 's#^bossDataSource.url=.*$#bossDataSource.url='"$bossDataSource_url"'#' $WEBSITE/db.properties
    # Boss库用户名
    sed -i 's#^bossDataSource.username=.*$#bossDataSource.username='"$bossDataSource_username"'#' $WEBSITE/db.properties
    # Boss库用户密码
    sed -i 's#^bossDataSource.password=.*$#bossDataSource.password='"$bossDataSource_password"'#' $WEBSITE/db.properties

    # 运营商库连接地址
    sed -i 's#^mainsiteDataSource.url=.*$#mainsiteDataSource.url='"$mainsiteDataSource_url"'#' $WEBSITE/db.properties
    # 运营商库用户名
    sed -i 's#^mainsiteDataSource.username=.*$#mainsiteDataSource.username='"$mainsiteDataSource_username"'#' $WEBSITE/db.properties
    # 运营商库用户密码
    sed -i 's#^mainsiteDataSource.password=.*$#mainsiteDataSource.password='"$mainsiteDataSource_password"'#' $WEBSITE/db.properties

    # 统计库连接地址
    sed -i 's#^statDataSource.url=.*$#statDataSource.url='"$statDataSource_url"'#' $WEBSITE/db.properties
    # 统计库用户名
    sed -i 's#^statDataSource.username=.*$#statDataSource.username='"$statDataSource_username"'#' $WEBSITE/db.properties
    # 统计库用户密码
    sed -i 's#^statDataSource.password=.*$#statDataSource.password='"$statDataSource_password"'#' $WEBSITE/db.properties

    # 历史库连接地址
    sed -i 's#^historyDataSource.url=.*$#historyDataSource.url='"$historyDataSource_url"'#' $WEBSITE/db.properties
    # 历史库用户名
    sed -i 's#^historyDataSource.username=.*$#historyDataSource.username='"$historyDataSource_username"'#' $WEBSITE/db.properties
    # 历史库用户密码
    sed -i 's#^historyDataSource.password=.*$#historyDataSource.password='"$historyDataSource_password"'#' $WEBSITE/db.properties

    # 备份库连接地址
    sed -i 's#^backupDataSource.url=.*$#backupDataSource.url='"$backupDataSource_url"'#' $WEBSITE/db.properties
    # 备份库用户名
    sed -i 's#^backupDataSource.username=.*$#backupDataSource.username='"$backupDataSource_username"'#' $WEBSITE/db.properties
    # 备份库用户密码
    sed -i 's#^backupDataSource.password=.*$#backupDataSource.password='"$backupDataSource_password"'#' $WEBSITE/db.properties

    # ApiLog库连接地址
    sed -i 's#^apiLogDataSource.url=.*$#apiLogDataSource.url='"$apiLogDataSource_url"'#' $WEBSITE/db.properties
    # ApiLog库用户名
    sed -i 's#^apiLogDataSource.username=.*$#apiLogDataSource.username='"$apiLogDataSource_username"'#' $WEBSITE/db.properties
    # ApiLog库用户密码
    sed -i 's#^apiLogDataSource.password=.*$#apiLogDataSource.password='"$apiLogDataSource_password"'#' $WEBSITE/db.properties

fi

# [db-conf.properties]
if [ -f $WEBSITE"/db-conf.properties" ]; then
    # 用户密码是否需要解密
    sed -i 's#^password.decrypt=.*$#password.decrypt='"$password_decrypt"'#' $WEBSITE/db-conf.properties
    # Boss库连接地址
    sed -i 's#^bossDataSource.url=.*$#bossDataSource.url='"$bossDataSource_url"'#' $WEBSITE/db-conf.properties
    # Boss库用户名
    sed -i 's#^bossDataSource.username=.*$#bossDataSource.username='"$bossDataSource_username"'#' $WEBSITE/db-conf.properties
    # Boss库用户密码
    sed -i 's#^bossDataSource.password=.*$#bossDataSource.password='"$bossDataSource_password"'#' $WEBSITE/db-conf.properties

    # 运营商库连接地址
    sed -i 's#^mainsiteDataSource.url=.*$#mainsiteDataSource.url='"$mainsiteDataSource_url"'#' $WEBSITE/db-conf.properties
    # 运营商库用户名
    sed -i 's#^mainsiteDataSource.username=.*$#mainsiteDataSource.username='"$mainsiteDataSource_username"'#' $WEBSITE/db-conf.properties
    # 运营商库用户密码
    sed -i 's#^mainsiteDataSource.password=.*$#mainsiteDataSource.password='"$mainsiteDataSource_password"'#' $WEBSITE/db-conf.properties

    # 统计库连接地址
    sed -i 's#^statDataSource.url=.*$#statDataSource.url='"$statDataSource_url"'#' $WEBSITE/db-conf.properties
    # 统计库用户名
    sed -i 's#^statDataSource.username=.*$#statDataSource.username='"$statDataSource_username"'#' $WEBSITE/db-conf.properties
    # 统计库用户密码
    sed -i 's#^statDataSource.password=.*$#statDataSource.password='"$statDataSource_password"'#' $WEBSITE/db-conf.properties

    # 历史库连接地址
    sed -i 's#^historyDataSource.url=.*$#historyDataSource.url='"$historyDataSource_url"'#' $WEBSITE/db-conf.properties
    # 历史库用户名
    sed -i 's#^historyDataSource.username=.*$#historyDataSource.username='"$historyDataSource_username"'#' $WEBSITE/db-conf.properties
    # 历史库用户密码
    sed -i 's#^historyDataSource.password=.*$#historyDataSource.password='"$historyDataSource_password"'#' $WEBSITE/db-conf.properties

    # 备份库连接地址
    sed -i 's#^backupDataSource.url=.*$#backupDataSource.url='"$backupDataSource_url"'#' $WEBSITE/db-conf.properties
    # 备份库用户名
    sed -i 's#^backupDataSource.username=.*$#backupDataSource.username='"$backupDataSource_username"'#' $WEBSITE/db-conf.properties
    # 备份库用户密码
    sed -i 's#^backupDataSource.password=.*$#backupDataSource.password='"$backupDataSource_password"'#' $WEBSITE/db-conf.properties

    # ApiLog库连接地址
    sed -i 's#^apiLogDataSource.url=.*$#apiLogDataSource.url='"$apiLogDataSource_url"'#' $WEBSITE/db-conf.properties
    # ApiLog库用户名
    sed -i 's#^apiLogDataSource.username=.*$#apiLogDataSource.username='"$apiLogDataSource_username"'#' $WEBSITE/db-conf.properties
    # ApiLog库用户密码
    sed -i 's#^apiLogDataSource.password=.*$#apiLogDataSource.password='"$apiLogDataSource_password"'#' $WEBSITE/db-conf.properties
fi


# [redis-conf.properties]
if [ -f $WEBSITE"/redis-conf.properties" ]; then
    # ----------------------------- 集群配置
    # 普通数据redis服务器地址
    sed -i 's#^data.redis.hosts=.*$#data.redis.hosts='"$data_redis_hosts"'#' $WEBSITE/redis-conf.properties
    # 页面静态化redis服务器地址
    sed -i 's#^pageCache.redis.hosts=.*$#pageCache.redis.hosts='"$pageCache_redis_hosts"'#' $WEBSITE/redis-conf.properties
    # api数据redis服务器地址
    sed -i 's#^gameApi.redis.hosts=.*$#gameApi.redis.hosts='"$gameApi_redis_hosts"'#' $WEBSITE/redis-conf.properties
    # api数据redis服务器地址 ---------------- 2018 10 26
    sed -i 's#^api.token.hosts=.*$#api.token.hosts='"$api_token_hosts"'#' $WEBSITE/redis-conf.properties
    # Web session redis服务器地址
    sed -i 's#^shiro.session.hosts=.*$#shiro.session.hosts='"$shiro_session_hosts"'#' $WEBSITE/redis-conf.properties
    # Shiro权限数据redis服务器地址
    sed -i 's#^shiro.auth.hosts=.*$#shiro.auth.hosts='"$shiro_auth_hosts"'#' $WEBSITE/redis-conf.properties
    # Gather数据redis服务器地址
    sed -i 's#^gather.redis.hosts=.*$#gather.redis.hosts='"$gather_redis_hosts"'#' $WEBSITE/redis-conf.properties

    # ----------------------------- 非集群配置
    # 普通数据redis服务器地址
    sed -i 's#^data.redis.host=.*$#data.redis.host='"$data_redis_host"'#' $WEBSITE/redis-conf.properties
    # 页面静态化redis服务器地址
    sed -i 's#^pageCache.redis.host=.*$#pageCache.redis.host='"$pageCache_redis_host"'#' $WEBSITE/redis-conf.properties
    # api数据redis服务器地址
    sed -i 's#^gameApi.redis.host=.*$#gameApi.redis.host='"$gameApi_redis_host"'#' $WEBSITE/redis-conf.properties
    # api数据redis服务器地址 ---------------- 2018 10 26
    sed -i 's#^api.token.host=.*$#api.token.host='"$api_token_host"'#' $WEBSITE/redis-conf.properties
    # Web session redis服务器地址
    sed -i 's#^shiro.session.host=.*$#shiro.session.host='"$shiro_session_host"'#' $WEBSITE/redis-conf.properties
    # Shiro权限数据redis服务器地址
    sed -i 's#^shiro.auth.host=.*$#shiro.auth.host='"$shiro_auth_host"'#' $WEBSITE/redis-conf.properties
    # Gather数据redis服务器地址
    sed -i 's#^gather.redis.host=.*$#gather.redis.host='"$gather_redis_host"'#' $WEBSITE/redis-conf.properties
fi


# [web-base-conf.properties]
if [ -f $WEBSITE"/web-base-conf.properties" ]; then
    # Dubbo端口
    sed -i 's#^dubbo.port=.*$#dubbo.port='"$dubbo_port"'#' $WEBSITE/web-base-conf.properties
    # 各站点地址模板
    sed -i 's#^website.uri=.*$#website.uri='"$website_uri"'#' $WEBSITE/web-base-conf.properties
    # 静态资源地址模板
    sed -i 's#^ressite.uri=.*$#ressite.uri='"$ressite_uri"'#' $WEBSITE/web-base-conf.properties
    # 公共资源地址模板
    sed -i 's#^comressite.uri=.*$#comressite.uri='"$comressite_uri"'#' $WEBSITE/web-base-conf.properties
    # 图片上传资源地址
    sed -i 's#^imgsite.uri=.*$#imgsite.uri='"$imgsite_uri"'#' $WEBSITE/web-base-conf.properties
    # 消息中心comet地址模板
    sed -i 's#^mdsite.uri=.*$#mdsite.uri='"$mdsite_uri"'#' $WEBSITE/web-base-conf.properties
    # 消息中心地址
    sed -i 's#^mdsite.ip=.*$#mdsite.ip='"$mdsite_ip"'#' $WEBSITE/web-base-conf.properties
    # 资源文件版本
    sed -i 's#^rcenter.version=.*$#rcenter.version='"$rcVersion"'#' $WEBSITE/web-base-conf.properties

    # 站点(msites)页面模板文件存放的目录
    sed -i 's#^freemaker.template.root.path=.*$#freemaker.template.root.path='"$freemaker_template_root_path"'#' $WEBSITE/web-base-conf.properties
fi

# [service-conf.properties]
if [ -f $WEBSITE"/service-conf.properties" ]; then
    # mongoDb服务器地址和端口
    sed -i 's#^mongodb.url=.*$#mongodb.url='"$mongodb_url"'#' $WEBSITE/service-conf.properties
    # 消息队列服务器地址和端口
    sed -i 's#^rocketMQ.namesrvAddr=.*$#rocketMQ.namesrvAddr='"$rocketMQ_namesrvAddr"'#' $WEBSITE/service-conf.properties
    # 消息队列本地异常信息存放目录
    sed -i 's#^local.store.db.home=.*$#local.store.db.home='"$rdb_dir"'#' $WEBSITE/service-conf.properties
    #配置替换Api-Jar的目录为空
    sed -i "s/^#gameboxApi.jarRootPath=.*$/gameboxApi.jarRootPath=/" $WEBSITE/service-conf.properties
    # 机房编号
    sed -i 's#^belong.idc=.*$#belong.idc='"$belong_idc"'#' $WEBSITE/service-conf.properties
fi

# [uploadConst.properties]
if [ -f $WEBSITE"/uploadConst.properties" ]; then
    # 文件上传的临时目录
    sed -i 's#^tempPath=.*$#tempPath='"$file_upload_tmp"'#' $WEBSITE/uploadConst.properties
    # 文件上传的最终目录
    sed -i 's#uploadPath=.*$#uploadPath='"$file_upload_data"'#' $WEBSITE/uploadConst.properties
fi


# [boss-conf.properties]
if [ -f $WEBSITE"/boss-conf.properties" ]; then
    # idc间同步数据的url
    sed -i 's#^sync.idc.url=.*$#sync.idc.url='"$sync_idc_url"'#' $WEBSITE/boss-conf.properties
    # 消息队列服务器地址和端口
    sed -i 's#^rocketMQ.namesrvAddr=.*$#rocketMQ.namesrvAddr='"$rocketMQ_namesrvAddr"'#' $WEBSITE/boss-conf.properties
fi

# [mdcenter-mq-conf.properties]
if [ -f $WEBSITE"/mdcenter-mq-conf.properties" ]; then
    # 消息队列服务器地址和端口
    sed -i 's#^rocketMQ.namesrvAddr=.*$#rocketMQ.namesrvAddr='"$rocketMQ_namesrvAddr"'#' $WEBSITE/mdcenter-mq-conf.properties
fi

# [mongo-conf.properties]
if [ -f $WEBSITE"/mongo-conf.properties" ]; then
    # mongoDb服务器地址
    sed -i 's#^mongodb.host=.*$#mongodb.host='"$mongodb_host"'#' $WEBSITE/mongo-conf.properties
    # mongoDb服务器端口
    sed -i 's#^mongodb.port=.*$#mongodb.port='"$mongodb_port"'#' $WEBSITE/mongo-conf.properties
fi

# [monitor-conf.properties]
if [ -f $WEBSITE"/monitor-conf.properties" ]; then
    # 消息队列服务器地址和端口
    sed -i 's#^rocketMQ.namesrvAddr=.*$#rocketMQ.namesrvAddr='"$rocketMQ_namesrvAddr"'#' $WEBSITE/monitor-conf.properties
    # 消息队列本地异常信息存放目录
    sed -i 's#^local.store.db.home=.*$#local.store.db.home='"$rdb_dir"'#' $WEBSITE/monitor-conf.properties
fi

#game-api采集器配置
# [gather-conf.properties]
if [ -f $WEBSITE"/gather-conf.properties" ]; then
    # Zookeeper的url及端口,多个用半角空格分隔
    if [ "$app" == "gather-client" ]; then
        #echo sed -i 's#^gather.zookeeper.url=.*$#gather.zookeeper.url='"$gather_zookeeper_url_client"'#' $WEBSITE/gather-conf.properties
        sed -i 's#^gather.zookeeper.url=.*$#gather.zookeeper.url='"$gather_zookeeper_url_client"'#' $WEBSITE/gather-conf.properties
    fi
    if [ "$app" == "gather-server" ]  || [ "$app" == "service" ] || [ "$app" == "api" ]  || [ "$app" == "service-api" ]; then
        #echo sed -i 's#^gather.zookeeper.url=.*$#gather.zookeeper.url='"$gather_zookeeper_url_server"'#' $WEBSITE/gather-conf.properties
        # Zookeeper的url及端口,多个用半角空格分隔
        sed -i 's#^gather.zookeeper.url=.*$#gather.zookeeper.url='"$gather_zookeeper_url_server"'#' $WEBSITE/gather-conf.properties
        sed -i 's#^gather.zookeeper.node.prefix=.*$#gather.zookeeper.node.prefix='"$gather_zookeeper_node_prefix"'#' $WEBSITE/gather-conf.properties
    fi

    # 采集器版本号
    sed -i 's#^gather.version=.*$#gather.version='"$gather_version"'#' $WEBSITE/gather-conf.properties

fi

# [base.properties]
if [ -f $WEBSITE"/base.properties" ]; then
    # 反向代理采集的nginx的地址
    sed -i 's#^gather.zookeeper.node.nginx=.*$#gather.zookeeper.node.nginx='"$gather_zookeeper_node_nginx"'#' $WEBSITE/base.properties
    # 是否由nginx反向代理
    sed -i 's#^gather.nginx.channel=.*$#gather.nginx.channel='"true"'#' $WEBSITE/base.properties
    # 访问级别
    sed -i 's#^gather.zookeeper.node.prefix=.*$#gather.zookeeper.node.prefix='"inner"'#' $WEBSITE/base.properties
    # zookeeper节点前缀
    sed -i "s/^gather.service.port=.*$/gather.service.port=9000/" $WEBSITE/base.properties
fi


# ---------- web-ds-conf.properties  Start 20171014----------
# [web-ds-conf.properties]
if [ -f $WEBSITE"/web-ds-conf.properties" ]; then
    sed -i "s|^ds.id.model.lottery=.*$|ds.id.model.lottery=${ds_id_model_lottery}|"  $WEBSITE/web-ds-conf.properties
    sed -i "s|^ds.id.model.mock.account=.*$|ds.id.model.mock.account=${ds_id_model_mock_account}|"  $WEBSITE/web-ds-conf.properties
    sed -i "s|^ds.id.model.platform=.*$|ds.id.model.platform=${ds_id_model_platform}|"  $WEBSITE/web-ds-conf.properties
fi
# ----------   web-ds-conf.properties  End 20171014 ----------


# ---------- lb mq地址 2018-05-37
# [mq-conf.properties]
if [ -f $WEBSITE"/mq-conf.properties" ]; then
    # 消息队列服务器地址和端口
    sed -i 's#^rocketMQ.namesrvAddr=.*$#rocketMQ.namesrvAddr='"$rocketMQ_namesrvAddr"'#' $WEBSITE/mq-conf.properties
fi

# ---------- lb 本地缓存地址 2018-05-37
file_list=" server-conf.properties schedule-conf.properties game-schedule-conf.properties "
for file in $file_list; do
    if [ -f $WEBSITE"/$file" ]; then
        # mongoDb服务器地址和端口
        sed -i 's#^mongodb.url=.*$#mongodb.url='"$mongodb_url"'#'                             $WEBSITE"/$file"
        # 消息队列服务器地址和端口
        sed -i 's#^rocketMQ.namesrvAddr=.*$#rocketMQ.namesrvAddr='"$rocketMQ_namesrvAddr"'#'  $WEBSITE"/$file"
        # 消息队列本地异常信息存放目录
        sed -i 's#^local.store.db.home=.*$#local.store.db.home='"$rdb_dir"'#'                 $WEBSITE"/$file"
        #配置替换Api-Jar的目录为空
        sed -i "s/^#gameboxApi.jarRootPath=.*$/gameboxApi.jarRootPath=/"                      $WEBSITE"/$file"
        # 机房编号
        sed -i 's#^belong.idc=.*$#belong.idc='"$belong_idc"'#'                                $WEBSITE"/$file"
    fi
done
