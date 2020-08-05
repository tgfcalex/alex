#/bin/bash
docker network create --attachable -d overlay --subnet=10.100.0.0/16 im_net
