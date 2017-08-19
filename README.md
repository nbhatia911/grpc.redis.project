# grpc.redis.project
Sample project to demo grpc client server (running inside docker) and using redis api in go language to communicate with redis server

Download https://github.com/go-redis/redis/

compile.sh
- script to compile .proto files for go/grpc
- generate binaries for client server with and without docker
- create docker image using Dockerfile

start_docker_app.sh
- starts docker server image 

Project contains payment.pb.go which is auto generated from payment.proto using protoc compiler. 
