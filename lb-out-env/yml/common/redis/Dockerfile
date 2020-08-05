FROM redis:5.0.5


ADD  container-files /
RUN set -ex && chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 6379
CMD [ "redis-server", "/etc/redis.conf" ]

