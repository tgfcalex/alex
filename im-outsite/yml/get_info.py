#!/usr/bin/env python2

import socket
import re

composesrvs = ("api", "app", "adm", "test", "site", "sync", "source")
host_name = socket.gethostname()
regex = r'^(?P<platform>[a-zA-Z]+)(?P<idc>\d?)-(?P<stype>[a-zA-Z]+)-\d+'
info = re.search(regex, host_name)

try:
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
            print(
                '\tplatform={}\n\tidc={}\n\tcomposesrv={}\n\tstype={}\n'.format(
                    platform, idc, composesrv, stype))
except Exception as exc:
    print('[\033[31mERR\033[0m]invalid hostname: \033[31m{}\033[0m\n----\n{}'.format(host_name, exc))
    exit(1)

