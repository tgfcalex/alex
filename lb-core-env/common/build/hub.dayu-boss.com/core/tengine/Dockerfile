FROM hub.dawoo.com/core/centos-tengine

RUN \
  set -ex \
  && echo -e "#!/bin/bash\n\
      nginx -s reload && echo Nginx reload...OK" > /usr/bin/restart.sh \
  && chmod +x /usr/bin/restart.sh

VOLUME /usr/local/nginx/conf/  /data/nginx/logs/

WORKDIR /usr/local/nginx/

HEALTHCHECK --interval=10s --timeout=8s --retries=5 \
          CMD port_check 80
          
COPY nginx.ini /etc/supervisord.d/
ENTRYPOINT ["tini", "--"]
CMD [ "/usr/bin/supervisord" ]
