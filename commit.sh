#!/usr/bin/env bash

_APP_VERSION=$(cat ./VERSION)

git add .
git commit -m "$_APP_VERSION"
git tag -a "v$_APP_VERSION" -m "$_APP_VERSION"
