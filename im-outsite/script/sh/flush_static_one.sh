#!/bin/bash
# *-* paul
#alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
#3b=`urldecode $1`
#echo $b >> /etc/paul

str=$1
#key=`echo -n $str|openssl md5|cut -d ' ' -f2`

val1=${str:0-1}
val2=${str:0-3:0-1}
echo $val1
echo $val2
rm -f /tmp/proxy_cache/$val1/$val2/$str
