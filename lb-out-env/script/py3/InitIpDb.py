#!/usr/bin/env python3
# coding: utf-8
import hashlib
import re
import zipfile
import redis
import logging

logging.basicConfig(
    level=logging.WARNING,
    format='%(asctime)s %(levelname)s %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    filename='/dev/stdout',
    filemode='w',
)
logger = logging.getLogger()


class InitIpDb:
    def __init__(self):
        self.ip_db_file_dir = '/tmp'
        self.ip_db_file = self.ip_db_file_dir + '/ip_db.txt'
        self.zip_file = './ip_db.zip'
        rds = redis.Redis(unix_socket_path='/var/run/redis/redis.sock', db=6, password="gamebox123")

    def md5sum(self, filename):
        with open(filename, mode='rb') as f:
            d = hashlib.md5()
            while True:
                buf = f.read(4096)
                if not buf:
                    break
                d.update(buf)
            return d.hexdigest()

    def main(self):
        rds = redis.Redis(unix_socket_path='/var/run/redis/redis.sock', db=9, password="gamebox123")
        md5_key = 'ip_db_md5'

        if zipfile.is_zipfile(self.zip_file):
            file_md5 = self.md5sum(self.zip_file).encode(encoding="utf-8")
            rds_md5 = rds.get(md5_key)
            if file_md5 == rds_md5 and rds.exists('ip_db'):
                logger.info('%-20s\t内容没有更改，md5：%s ！' % ('ip_db', file_md5))
                return
            else:
                logger.info(
                    '%-20s\tRunning...... \n\tfile_md5: %s\n\trds_md5:  %s' %
                    ('InitIpDb', file_md5, rds_md5))
                f = zipfile.ZipFile(self.zip_file)
                f.extractall(self.ip_db_file_dir)
                f.close()
        else:
            logger.info('%-10s\tinvalid file' % self.zip_file)
            return

        rds.flushdb()
        with open(self.ip_db_file, 'r') as file:
            index = 0
            for line in file:
                group = 150000  # 分批 pipe
                compl = index % group
                if compl == 0:
                    pipe = rds.pipeline()
                line = re.sub(r',(中国),(香港|澳门|台湾),', r',\2,\2,', line)
                parts = line.strip().split(',')
                score = parts[1]  # 结束ip当作score值
                value = '{ip_start},{country},{province},{city},{isp}'.format(
                    ip_start=parts[0], country=parts[4], province=parts[5], city=parts[6], isp=parts[7])
                pipe.zadd('ip_db', {value: score})
                if compl + 1 == group:
                    logger.info('pipe.execute()\t%-10s' % index)
                    pipe.execute()
                index = index + 1
            pipe.set(md5_key, file_md5)
            logger.info('pipe.execute()\t%-10s' % index)
            pipe.execute()


if __name__ == '__main__':
    InitIpDb().main()
