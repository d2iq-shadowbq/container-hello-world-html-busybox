#!/usr/bin/env bash

# Ensure tunnelblick is setfor Docker for Mac if using OSX

_APP_VERSION=$(cat ./VERSION)
docker login

docker image tag "hello-world:$_APP_VERSION" "d2iqshadowbq/hello-world:$_APP_VERSION"
docker image push "d2iqshadowbq/hello-world:$_APP_VERSION"
