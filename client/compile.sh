#!/bin/bash

# use protoc compiler to generate pb.go file with grpc
protoc -I ../proto/ ../proto/payment.proto --go_out=plugins=grpc:proto

# compiles binary without docker
go build -o client1 -v main.go

# compiles binary without docker
#CGO_ENABLED=0 GOOS=linux go build -o client1_docker  -a -installsuffix cgo -v client/main.go 

# creates docker image
#docker build -t my_grpc_client -f DockerfileClient .
