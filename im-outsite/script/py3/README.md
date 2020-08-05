# 说明

基于 python3 模块 schedule 定时3分钟获取接口数据（site_info, domains...） 并存入redis。

    1. python 容器 run 的时候需要指定环境变量 (platform, stype, idc);
    2. ip 库存入 9 库， 存入类型：有序集合(sorted set);
    3. sync 获取核心机房数据存入 6 库， 存入类型： 字符串;
    4. 其他外围获取 sync 接口数据，存入 6 库， 存入类型： 字符串， 同时记录 md5;
    5. 其他外围校验 6 库相应数据， 整理存入 0 库：
        a) 站点信息： 
            类型 String
            key 为： site:<SITE_ID>
        b) 域名信息：
            类型 Hash
            key 为： domain:<DOMAIN>
            field1: "siteId"
            field2: "subsysCode"
            field3: "pageUrl"
