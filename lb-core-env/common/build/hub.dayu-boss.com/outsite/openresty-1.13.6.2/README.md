# openresty-1.13.6.2 更新说明
**By sun  ==> 2018.6.23**

# dockerfile 修改内容
```markdown
1. 修改openresty下载路径，nginx版本1.13
2、补丁文件修改：
patch -p0 < /usr/local/src/nginx_upstream_check_module/check_1.11.5+.patchpatch -p0 < /usr/local/src/nginx_upstream_check_module/check_1.11.5+.patch
3、openresty编译时报错：
   修改nginx upstream-fair模块源码文件
  参考github连接：
    https://www.codetd.com/article/64432
4、openresty取消启用ngx_google_perftools_module 模块
```

# 容器安装内容：
  1、 openresty
  2、redis  用于外围存储域名