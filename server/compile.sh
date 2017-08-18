#!/bin/bash

# use protoc compiler to generate pb.go file with grpc
protoc -I ../proto/ ../proto/payment.proto --go_out=plugins=grpc:proto

# compiles binary without docker
go build -o server1 -v main.go

# compiles binary with docker
CGO_ENABLED=0 GOOS=linux go build -o server1_docker  -a -installsuffix cgo -v main.go 

# creates docker image
docker build -t my_grpc_server -f DockerfileServer .
