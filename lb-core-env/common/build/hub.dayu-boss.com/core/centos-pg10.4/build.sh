#!/usr/bin/env bash

# by Tim

cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${cur_dir}/../_variable.sh

sudo docker pull centos:7


image_NAME="hub.dayu-boss.com/core/$(basename ${cur_dir})"

build_cmd
