
# grpc.redis.project
Sample project to demo grpc client server (running inside docker) and using redis api in go language to communicate with redis server. Deployment for redis server and grpc server done on kubernetes in Virtual Box VM.

GRPC Server docker hub image - https://hub.docker.com/r/nbhatia911/grpc.redis.project/ 

Redis client - https://github.com/go-redis/redis/

Redis Server docker hub image - https://hub.docker.com/_/redis/

Ubuntu can be installed on Windows Host for developement which we are using for this project, scroll to end for details.

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

<pre>

watch kubectl get pods --all-namespaces
kubectl get all

NAMESPACE     NAME                                     READY     STATUS    RESTARTS   AGE
default       mygrpcserver-2593759886-ktgzb            1/1       Running   0          9m
default       redis-3356651156-t7ktp                   1/1       Running   0          9m

</pre>



## IMPORTANT
1. If running kubernetes on VM make sure that MASTER/SLAVE have unique hostnames. Edit /etc/hostname. IP address must be routable. Add SLAVES ip address in MASTER

2. If MASTER is started with IP 192.168.56.106, then add below route to all SLAVES. If not weave net will keep crashing.


<pre>

Get cluster IP using
kubectl get svc

NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   10.96.0.1    <none>        443/TCP   2h

route add 10.96.0.1 gw 192.168.56.106
</pre>

3. Always start kubernetes without NAT ip address. NAT ip address can be same for all VM and kubernetes won't start

<pre>
kubeadm init --apiserver-advertise-address=192.168.56.106 --token-ttl 0

Make sure you are connected to internet else kubeadm will complaint and won't start properly. To bypass internet user --kubernetes-version

kubeadm init --apiserver-advertise-address=192.168.56.106 --token-ttl 0 --kubernetes-version v1.7.3
</pre>

4. Dns pod will keep crashing if weave network is not installed on master. Install using below cmds on master, weave net is not needed on slaves.

<pre>
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
kubectl apply -f https://git.io/weave-kube < --- Do not use this cmd
</pre>

## USEFUL COMMANDS


### KUBERNETES SERVER

#### To delete and reset kubernetes on master/slave

<pre>

kubeadm reset 
rm -rf /etc/kubernetes/*
rm -rf /var/run/kubernetes/*
rm -rf /run/kubernetes/
</pre>

#### Start kubernetes
<pre>

kubeadm init --apiserver-advertise-address=192.168.56.106 --token-ttl 0 - This should be master ip of VM not NAT IP

</pre>

#### Create/delete namespaces
<pre>

kubectl delete namespace sock-shop
kubectl create namespace sock-shop
kubectl -n sock-shop get svc front-end
</pre>

#### Start dashboard
<pre>
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
kubectl proxy - starts dashboard
</pre>

#### Install sample application
<pre>
kubectl create namespace sock-shop
kubectl apply -n sock-shop -f "https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true"
</pre>

#### Debug kubernetes
<pre>

kubectl get all
kubectl get pods --all-namespaces
kubectl describe services
kubectl get nodes

kubectl describe node minion01 - check logs

</pre>

### KUBERNETES MINION

<pre>

kubeadm join --token 63b3a2.270385143487e152 192.168.56.106:6443
kubectl get pods -n sock-shop
kubectl describe svc front-end -n sock-shop

</pre>

### DOCKER

<pre>

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

</pre>

### LXC

<pre>

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

</pre>

# STEPS TO CONFIGURE UBUNTU 16.04 XENIAL

## INSTALL DOCKER VERSION 17.05

<pre>

apt-get update
apt-get remove docker docker-engine docker.io
apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update


apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
apt-get update

apt-cache policy docker-engine
apt-get -y install docker-engine=17.05.0~ce-0~ubuntu-xenial docker.io=1.12.6-0ubuntu1~16.04.1

docker version
docker run hello-world

</pre>

## INSTALL KUBERNETES VERSION 1.7.3

<pre>

apt-get update && apt-get install -y apt-transport-https
apt-get update
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list 
apt-get update
apt-get -y install kubectl=1.7.3-01 kubelet=1.7.3-01 kubeadm=1.7.3-01 kubernetes-cni=0.5.1-00

</pre>

## CHECK INSTALLATION

<pre>

docker verion
kubectl version

kubectl get pods --all-namespaces
NAMESPACE     NAME                                     READY     STATUS    RESTARTS   AGE
default       mygrpcserver-2593759886-ktgzb            1/1       Running   0          1h
default       redis-3356651156-t7ktp                   1/1       Running   0          1h
kube-system   etcd-tpi-virtualbox                      1/1       Running   5          9h
kube-system   kube-apiserver-tpi-virtualbox            1/1       Running   5          9h
kube-system   kube-controller-manager-tpi-virtualbox   1/1       Running   5          9h
kube-system   kube-dns-2425271678-j626h                3/3       Running   15         9h
kube-system   kube-proxy-61xpc                         1/1       Running   5          9h
kube-system   kube-proxy-bmrl8                         1/1       Running   3          6h
kube-system   kube-scheduler-tpi-virtualbox            1/1       Running   5          9h
kube-system   kubernetes-dashboard-3313488171-8lk0n    1/1       Running   5          8h
kube-system   weave-net-gw3pr                          2/2       Running   13         6h
kube-system   weave-net-x99m5                          2/2       Running   10         8h


dpkg -l  |grep kube
ii  kubeadm                                    1.7.3-01                                   amd64        Kubernetes Cluster Bootstrapping Tool
ii  kubectl                                    1.7.3-01                                   amd64        Kubernetes Command Line Tool
ii  kubelet                                    1.7.3-01                                   amd64        Kubernetes Node Agent
ii  kubernetes-cni                             0.5.1-00                                   amd64        Kubernetes CNI
root@tpi-VirtualBox:~# dpkg -l  |grep docker
rc  docker-engine                              17.05.0~ce-0~ubuntu-xenial                 amd64        Docker: the open-source application container engine
ii  docker.io                                  1.12.6-0ubuntu1~16.04.1                    amd64        Linux container runtime
ii  runc                                       1.0.0~rc2+docker1.12.6-0ubuntu1~16.04.1    amd64        Open Container Project - runtime
</pre>


## To install and compile code on Ubuntu follow the below steps

1. Install Virtual Box on Windows host - http://download.virtualbox.org/virtualbox/

Version we installed

http://download.virtualbox.org/virtualbox/5.1.22/VirtualBox-5.1.22-115126-Win.exe


2. Download 64bit Ubuntu desktop image and install in Virtual Box - http://releases.ubuntu.com

#### For this project we are using below image
<pre>
cat /etc/*release*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.3 LTS"
NAME="Ubuntu"
VERSION="16.04.3 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.3 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
</pre>

3. Make sure you have internet connectivity in Virtual Box, create 2 network adapters.

<pre>
#### NAT for internet
Do not use this ip for kubenetes

#### Host-only Adapter to VirtualBox Host-only ethernet adapter
IP address on this interface shall be used to configure kubernetes for master and slave. 
In advanced config set promiscuous mode to allow all

</pre>

4. Install docker, lxc, golang, protoc compiler, grpc
