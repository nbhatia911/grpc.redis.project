#!/bin/bash

protoc -I ../proto/ ../proto/payment.proto --go_out=plugins=grpc:proto
go build -o server1 -v main.go
CGO_ENABLED=0 GOOS=linux go build -o server1_docker  -a -installsuffix cgo -v main.go 
docker build -t my_grpc_server -f DockerfileServer .
