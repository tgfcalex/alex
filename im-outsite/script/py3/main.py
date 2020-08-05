#!/usr/bin/env python3
import os
import schedule
import time

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


if __name__ == "__main__":
    stype = os.getenv('stype')
    TimedJob().main()
