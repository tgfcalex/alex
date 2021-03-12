#!/bin/bash

docker stack deploy -c  01_im-user.yml im
  sleep 2
docker stack deploy -c  02_im-api.yml  im
  sleep 2
docker stack deploy -c  03_im-server.yml im
  sleep 2
docker stack deploy -c  04_im-gateway.yml im
  sleep 2
docker stack deploy -c  05_im-push.yml im
  sleep 2
docker stack deploy -c  06_im-robot.yml im
  sleep 2
docker stack deploy -c  07_im-file.yml im
  sleep 12
docker stack deploy -c  08_im-admin.yml im
  sleep 2
docker stack deploy -c  09_im-task.yml im
  sleep 2
docker stack deploy -c  10_im-smarttalk.yml im
  sleep 2
docker stack deploy -c  11_im-chatbot.yml im
  sleep 2
docker stack deploy -c  12_im_web-download.yml im
  sleep 2
docker stack deploy --compose-file 13_im_web-smarttalk-cmd.yml im
  sleep 2
docker stack deploy --compose-file 14_im_website-cmd.yml im


