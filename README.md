
# grpc.redis.project
Sample project to demo grpc client server (running inside docker) and using redis api in go language to communicate with redis server. Deployment for redis server and grpc server done on kubernetes in Virtual Box VM.

GRPC Server docker hub image - https://hub.docker.com/r/nbhatia911/grpc.redis.project/ 

Redis client - https://github.com/go-redis/redis/

Redis Server docker hub image - https://hub.docker.com/_/redis/

## KUBERNETES DASHBOARD - Click on pics to enlarge

<p align="center">
  <img src="https://github.com/nbhatia911/grpc.redis.project/blob/master/kubernetes-dashboard-pics/01_kubernetes-dasboard-all-nodes.jpg?raw=true" width="320"/>
  <img src="https://github.com/nbhatia911/grpc.redis.project/blob/master/kubernetes-dashboard-pics/02_kubernetes-dasboard-pods-running-on-slave.jpg?raw=true" width="320"/>
  <img src="https://github.com/nbhatia911/grpc.redis.project/blob/master/kubernetes-dashboard-pics/03_kubernetes-dasboard-grpc-server-pod-details01.jpg?raw=true" width="320"/>
  <img src="https://github.com/nbhatia911/grpc.redis.project/blob/master/kubernetes-dashboard-pics/04_kubernetes-dasboard-grpc-server-pod-details02.jpg?raw=true" width="320"/>
</p>

## COMPILE
#### server/compile.sh
- script to compile .proto files for go/grpc
- generate binaries for client server with and without docker
- create docker image using Dockerfile

#### server/start_docker_app.sh
- starts docker server image 

#### server/start_push_docker_hub.sh
- pushes images to hub.docker.com

Note: Project contains payment.pb.go which is auto generated from payment.proto using protoc compiler. 

## DEPLOY ON KUBERNETES
Copy folder kubernetes-deployment to MASTER node and run start_create_microservices.sh. This script will download docker images from hub.docker.com on MASTER and distribute to MINIONS/NODES/SLAVES.

#### Verify deployment using 

#### kubectl get pods --all-namespaces, kubectl get all

NAMESPACE     NAME                                     READY     STATUS    RESTARTS   AGE

default       mygrpcserver-2593759886-ktgzb            1/1       Running   0          9m

default       redis-3356651156-t7ktp                   1/1       Running   0          9m



## IMPORTANT
1. If running kubernetes on VM make sure that MASTER/SLAVE have unique hostnames. Edit /etc/hostname. IP address must be routable. Add SLAVES ip address in MASTER

2. If MASTER is started with IP 192.168.56.106, then add below route to all SLAVES. If not weave net will keep crashing.

route add 10.96.0.1 gw 192.168.56.106

3. Always start kubernetes without NAT ip address. NAT ip address can be same for all VM and kubernetes won't start

kubeadm init --apiserver-advertise-address=192.168.56.106 --token-ttl 0

### Get cluster IP using

kubectl get svc

NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE

kubernetes   10.96.0.1    <none>        443/TCP   2h


## USEFUL COMMANDS


### KUBERNETES SERVER

#### To delete and reset kubernetes on master/slave

kubeadm reset

rm -rf /etc/kubernetes/*

rm -rf /var/run/kubernetes/*

rm -rf /run/kubernetes/


kubeadm init --apiserver-advertise-address=192.168.56.106 --token-ttl 0 - This should be master ip of VM not NAT IP

kubectl delete namespace sock-shop

kubectl create namespace sock-shop

kubectl -n sock-shop get svc front-end

kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml

kubectl proxy - starts dashboard

kubectl get all

kubectl get pods --all-namespaces

kubectl describe services

kubectl get nodes

kubectl describe node minion01 - check logs

### KUBERNETES MINION

kubeadm join --token 63b3a2.270385143487e152 192.168.56.103:6443

kubectl get pods -n sock-shop

kubectl describe svc front-end -n sock-shop
 

### DOCKER

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

### LXC

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

