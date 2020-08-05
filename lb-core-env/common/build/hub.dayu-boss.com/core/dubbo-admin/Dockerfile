FROM hub.dayu-boss.com/core/tomcat

# 基于java8编译的dubbo-admin
ADD container-files /
RUN set -ex \
  && chmod +x /usr/bin/entrypoint.sh \
  \
  && cd /usr/local/tomcat/webapps/ROOT \
  && unzip dubbo-admin-2.5.4-SNAPSHOT.war >/dev/null 2>&1 \
  && rm -rf dubbo-admin-2.5.4-SNAPSHOT.war

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
