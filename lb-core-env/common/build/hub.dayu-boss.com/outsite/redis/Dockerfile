FROM redis:4.0.6

RUN ln -svf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY ./redis.conf /etc/redis.conf
CMD [ "redis-server", "/etc/redis.conf" ]
