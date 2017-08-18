#!/bin/bash

protoc -I ../proto/ ../proto/payment.proto --go_out=plugins=grpc:proto
go build -o client1 -v main.go
#CGO_ENABLED=0 GOOS=linux go build -o client1_docker  -a -installsuffix cgo -v client/main.go 
#docker build -t my_grpc_client -f DockerfileClient .
