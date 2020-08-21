#!/usr/bin/env bash
# -*- coding:utf-8 -*-

# Author: Tim
#
cur_dir="$( cd $(dirname ${BASH_SOURCE[0]}) && pwd )"

source $cur_dir/../../../common/script/v-release/tomcat_stop_start_new.sh stop $@
