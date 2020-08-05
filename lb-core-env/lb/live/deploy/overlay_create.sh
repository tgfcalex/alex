#!/usr/bin/env bash


docker network create --attachable -d overlay --subnet=10.200.0.0/16 lbnet