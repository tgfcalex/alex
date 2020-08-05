#!/usr/bin/env python2
# -*- coding: utf-8 -*-

'''
根据主机名, 正则匹配获取相应的系统环境变量:
platform    平台
idc         机房
composesrv  对应 docker-compose 的 service name
stype       线路类型

变量会写入文件 /etc/profile.d/custom_env.sh
'''

import socket
import re

composesrvs = ("api", "app", "adm", "test", "site", "sync", "source")
host_name = socket.gethostname()
regex = r'^(?P<platform>[a-zA-Z]+)(?P<idc>\d?)-(?P<stype>[a-zA-Z]+)-\d+'
env_temp = '''
platform=%s
idc=%s
composesrv=%s
stype=%s

export platform idc composesrv stype
export PATH=$PATH:/var/%s/site-out/script/sh/
'''

try:
    info = re.search(regex, host_name)
    platform = info.group("platform")
    idc = info.group("idc") or 1
    composesrv = info.group("stype")

    if platform and idc and composesrv:
        if composesrv in composesrvs:
            if composesrv == 'app' or composesrv == 'source':
                stype = 'site'
                composesrv = 'site'
            elif composesrv == 'test':
                stype = 'site,adm,api'
            else:
                stype = composesrv

            result = env_temp % (platform, idc, composesrv, stype, platform)
            print(result)

            # 环境写入文件, 需要 root 权限操作文件
            env_file = '/etc/profile.d/custom_env.sh'
            with open(env_file, "w") as f:
                f.write(result)

except Exception as exc:
    print('[\033[31mERR\033[0m]invalid hostname: \033[31m{}\033[0m\n----\n{}'.format(host_name, exc))
    exit(1)

