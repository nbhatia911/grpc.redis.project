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


USEFUL COMMANDS
apt-get install lxc lxctl lxc-templates
apt-get -y install docker.io

docker pull ubuntu - this will download docker from internet
docker ps -a -q - list of all dockers containers running
docker rm `docker ps -a -q` - remove all dockers containers, this will not remove docker images installed
docker run -p 6379:6379 --name redis-docker-server -d redis - run docker and redirect all traffic on port 6379 to redis docker
docker images - list all docker images installed
docker rmi image_name - remove docker image installed
docker inspect container_id - if you want to check docker ipaddress
docker stop container_id
docker start container_id
docker run -i -t ubuntu /bin/bash - starts docker and gives bash shell

lxc-create -n ubuntu-container -t ubuntu -  this will download 300 MB from internet
lxc-start -n ubuntu-container -d
lxc-ls --fancy
lxc-console -n ubuntu-container
lxc-info -n ubuntu-container
lxc-stop -n ubuntu-container
lxc-ls --fancy ubuntu-container
lxc-clone ubuntu-container ubuntu-container2 - this will clone LXC just like we clone VM image
lxc-snapshot -n ubuntu-container - snapshot saved to /var/lib/lxcsnaps/
lxc-snapshot -n ubuntu-container -r snap0 - restore from snapshot
lxc-destroy -n ubuntu-container - this will delete LXC
lxc-cgroup -n ubuntu-container cpuset.cpus - print cgroup config variables
