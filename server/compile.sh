#!/bin/bash

# use protoc compiler to generate pb.go file with grpc
protoc -I ../proto/ ../proto/payment.proto --go_out=plugins=grpc:proto

# compiles binary without docker
go build -o grpc_server1 -v main.go

# compiles binary with docker
CGO_ENABLED=0 GOOS=linux go build -o grpc_server1_docker  -a -installsuffix cgo -v main.go 

echo
echo "### Deleting my_grpc_server docker images and containers"
# delete all docker containers running this image
temp_str=`docker ps -a | grep my_grpc_server | awk -F" " '{print "docker rm -f "$1}'`
${temp_str}

# delete docker image
docker rmi -f my_grpc_server
docker images


# creates docker image 
docker build -t my_grpc_server -f DockerfileServer .

# verify if images has been installed
docker images
docker ps -a
