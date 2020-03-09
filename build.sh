#!/usr/bin/env bash

docker build -t "hello-world:$(cat ./VERSION)" .
docker run -p 80:8005 hello-world
## open your browser and check http://localhost/
docker login
docker tag hello-world d2iqshadowbq/hello-world
docker push d2iqshadowbq/hello-world:latest
