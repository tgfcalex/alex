#!/usr/bin/env python3
import os
import schedule
import time
import logging

from InitIpDb  import InitIpDb
from FetchData import FetchData


class TimedJob:
    def __init__(self):
        self.job()

    def job(self):
        FetchData().main()
        if "site" in stype or "adm" in stype:
            InitIpDb().main()

    def main(self):
        # 每3分钟执行一次更新检查
        schedule.every(6).minutes.do(self.job)
        while True:
            schedule.run_pending()
            time.sleep(1)



start_info = '''
-------------------------------------------
platform = %s
stype = %s
idc = %s
conf_file = %s
-------------------------------------------
'''

if __name__ == "__main__":
    platform = os.environ['platform']
    stype = os.environ['stype']
    idc = os.environ['idc']
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    conf_file = '%s/%s/%s' % (cur_dir, platform, 'api_conf.json')

    logging.basicConfig(
        level=logging.WARNING,
        format='%(asctime)s %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        filename='/dev/stdout',
        filemode='w',
    )
    logger = logging.getLogger()
    logger.warning(start_info % (platform, stype, idc, conf_file))

    TimedJob().main()
