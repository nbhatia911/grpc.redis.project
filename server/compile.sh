#!/bin/bash

# use protoc compiler to generate pb.go file with grpc
protoc -I ../proto/ ../proto/payment.proto --go_out=plugins=grpc:proto

# compiles binary without docker
go build -o server1 -v main.go

# compiles binary with docker
CGO_ENABLED=0 GOOS=linux go build -o server1_docker  -a -installsuffix cgo -v main.go 

# delete docker image
echo
echo "### Deleting my_grpc_server docker images and containers"
docker rmi -f my_grpc_server
docker images

# delete all docker containers running this image
docker ps -a | grep my_grpc_server | awk -F" " '{print "docker rm -f "$1}' > check_run
sh -x check_run

# creates docker image 
docker build -t my_grpc_server -f DockerfileServer .

# verify if images has been installed
docker images
docker ps -a
