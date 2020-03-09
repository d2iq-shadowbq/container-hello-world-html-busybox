#!/usr/bin/env bash

# Ensure tunnelblick is setfor Docker for Mac if using OSX

_APP_VERSION=$(cat ./VERSION)
docker login

docker build -t "hello-world:$_APP_VERSION" .
docker run -p 80:8005 hello-world
curl -s http:///localhost |grep 'Hello World'
