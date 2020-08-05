#!/usr/bin/env python3

import json
import os
import time
import sys
import hashlib
import redis
import requests
import logging

logging.basicConfig(
    level=logging.WARNING,
    format='%(asctime)s %(levelname)s %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    filename='/dev/stdout',
    filemode='w',
)
logger = logging.getLogger()
requests.packages.urllib3.disable_warnings()


class FetchData:
    def __init__(self):
        self.platform = os.environ['platform']
        self.stype = os.environ['stype']
        self.idc = os.environ['idc']
        self.cur_dir = os.path.dirname(os.path.realpath(__file__))

        self.conf_file = '%s/%s/%s' % (self.cur_dir,
                                       self.platform, 'api_conf.json')
        self.s = requests.Session()
        if not os.path.exists(self.conf_file):
            logger.error("配置文件不存在: %s" % self.conf_file)
            exit(1)

    def get_url_dic(self, _from):
        _dic = {}
        with open(self.conf_file) as f:
            conf = f.read()
        try:
            conf_dic = json.loads(conf)
            _dic = conf_dic[_from]
            return _dic
        except Exception as exc:
            logger.error("{}: Error\n{}".format(self.conf_file, exc))
            sys.exit(2)

    def _md5(self, rds_key):
        rds = redis.Redis(unix_socket_path='/var/run/redis/redis.sock', db=6, password="gamebox123")
        content = rds.get(rds_key)
        if content:
            return hashlib.md5(content).hexdigest()
        return 'nill'

    def get_data_from_rds(self, rds_key):
        rds = redis.Redis(unix_socket_path='/var/run/redis/redis.sock', db=6, password="gamebox123")
        content = rds.get(rds_key)
        if content:
            logger.info("%-20s%s 成功获取redis" % (rds_key, type(content)))
            return content
        return 'nill'

    def _get(self, _url, params, rds_key, value_field):
        try:
            r = self.s.get(_url, params=params, timeout=5, verify=False)
            msg_set = (rds_key, r.url)
            if r.status_code == 200:
                if value_field is None:
                    value = r.text
                else:
                    value = getattr(r, value_field)
                if value.strip():
                    rds = redis.Redis(unix_socket_path='/var/run/redis/redis.sock', db=6, password="gamebox123")
                    rds.set(rds_key, value.strip())
                    logger.info("%-20s%s 获取接口数据成功！" % msg_set)
                    self.input_data(rds_key)
                else:
                    logger.info("%-20s%s 获取接口数据为空(可能内容未更改)！" % msg_set)
            elif r.status_code == 304:
                logger.info("%-20s%s 返回状态304,内容未更改！" % msg_set)
            else:
                logger.error("%-20s%s 请求地址返回状态非200!" % msg_set)
        except Exception as e:
            logger.error("%s 获取接口数据异常:\n\t%s" % (rds_key, e))

    def fetch_data_from_core(self):
        url_dic = self.get_url_dic('core')  # sync从核心机房取
        if url_dic:
            for conf_key, _url in url_dic.items():
                rds_key = 'core:{}'.format(conf_key)
                md5 = self._md5(rds_key)
                params = {"md5": md5}
                self._get(_url, params, rds_key, '_content')
                time.sleep(1)

    def _fetch_data_from_sync(self, _type):
        api_url = self.get_url_dic('sync')  # 外围从sync接口取
        rds_key = 'sync:{}_{}'.format(_type, self.idc)
        md5 = self._md5(rds_key)
        params = {"md5": md5, "type": _type, "idc": self.idc}
        self._get(api_url, params, rds_key, '_content')
        time.sleep(1)

    def fetch_data_from_sync(self):
        self._fetch_data_from_sync("domains")
        self._fetch_data_from_sync("site_info")

    def input_data(self, rds_key):
        content = self.get_data_from_rds(rds_key)
        if content:
            logger.info("%-20s%s 存入数据！" % (rds_key, type(content)))
            rds_data = json.loads(content)
            rds = redis.Redis(unix_socket_path='/var/run/redis/redis.sock', db=0, password="gamebox123")
            pipe = rds.pipeline()
            if 'site_info' in rds_key:
                for (site_id, info_items_dict) in rds_data.items():
                    input_key = "{}:{}".format('site', site_id)
                    pipe.set(input_key, json.dumps(info_items_dict))
            elif 'domains' in rds_key:
                for domain in rds_data:
                    if 'domain' in domain:
                        _domain = str.lower(domain['domain'])  # 域名强制转小写
                        del domain['domain']
                        # 写入redis( domain,siteId,subsysCode )
                        if not domain['pageUrl']:
                            domain['pageUrl'] = ''
                        input_key = "{}:{}".format('domain', _domain)
                        pipe.hmset(input_key, domain)
            pipe.execute()
        else:
            logger.error("%s 获取redis数据为空!" % rds_key)

    def main(self):
        if "sync" in self.stype:
            self.fetch_data_from_core()
        else:
            self.fetch_data_from_sync()


if __name__ == "__main__":
    FetchData().main()

