#!/bin/bash
image=$1
shift
cid=$(docker ps | grep "$image" | head -1 | cut -d' ' -f1)
docker exec $cid "$@"
