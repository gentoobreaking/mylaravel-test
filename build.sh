#!/bin/sh
export my_version='v0.2'

docker build -t mylaravel:"${my_version}" . --no-cache

