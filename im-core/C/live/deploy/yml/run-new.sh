#!/bin/bash

docker stack deploy -c  user.yml im
  sleep 2
docker stack deploy -c  api.yml  im
  sleep 2
docker stack deploy -c  server.yml im
  sleep 2
docker stack deploy -c  gateway.yml im
  sleep 2
docker stack deploy -c  push.yml im
  sleep 2
docker stack deploy -c  robot.yml im
  sleep 2
docker stack deploy -c  file.yml im
  sleep 12
docker stack deploy -c  admin.yml im
  sleep 2
docker stack deploy -c  task.yml im
  sleep 2
docker stack deploy -c  smarttalk.yml im
  sleep 2
docker stack deploy -c  chatbot.yml im
  sleep 2
docker stack deploy -c  web-download.yml im
  sleep 2
docker stack deploy --compose-file web-smarttalk.yml im
  sleep 2
docker stack deploy --compose-file website.yml im
  sleep 2
docker stack deploy --compose-file services.yml im
  sleep 2
