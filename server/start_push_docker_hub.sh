#!/bin/sh

export DOCKER_ID_USER=nbhatia911
docker login
docker images
docker tag my_grpc_server $DOCKER_ID_USER/grpc.redis.project
docker push $DOCKER_ID_USER/grpc.redis.project

