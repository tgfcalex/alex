#!/usr/bin/env bash
ALLPKG="
    api
    cache-service
    game-schedule
    hall
    manager
    mdcenter
    schedule
    server
"
RSPKG="
    fserver
    mobile-h5
    pc-h5
    rcenter
"
pay_impl_jars="pay-impl-jars"
for i in `ls /var/data/updatefile/release-0827-151657-sun/updatefile`;do
if  echo "${ALLPKG} ${RSPKG} pay-impl-jars" | grep -wq $i &>/dev/null;then
    echo "${ALLPKG}"
    echo  "$i : 未知的app更新，请确定${UPDATE_PATH}下的目录属于:" "   ${ALLPKG} ${RSPKG}"
    exit 3
fi
echo "test"
done
