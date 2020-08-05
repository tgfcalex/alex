#!/usr/bin/env bash

# Author: Tim
# Date  : 17-10-24

html_file='/usr/local/openresty/nginx/script/sh/is_flush/html'

if [[ ! -d `dirname $html_file` ]]; then
    mkdir -p `dirname $html_file`
fi
if [[ ! -f $html_file ]]; then
    echo 0 > $html_file
fi

flush_number=$(expr `cat $html_file` + 1)

echo $flush_number > $html_file

