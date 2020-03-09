#!/usr/bin/env bash

# Ensure tunnelblick is setfor Docker for Mac if using OSX

_APP_VERSION=$(cat ./VERSION)
docker login

docker build -t "hello-world:$_APP_VERSION" .
docker rm hello_world_test > /dev/null 2>&1
docker run -p 80:8005 --name hello_world_test hello-world > /dev/null 2>&1 &
sleep 5
curl -s http:///localhost |grep 'Hello World'
docker kill hello_world_test
docker rm hello_world_test > /dev/null 2>&1
