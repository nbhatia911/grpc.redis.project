#!/bin/sh
kubectl get services
kubectl get deployment
kubectl get pods


echo "Deleting old microservices"
kubectl delete -f redis-microservice.yaml
kubectl delete -f grpc-server-microservice.yaml

echo "Creating new microservices"
kubectl create -f redis-microservice.yaml
kubectl create -f grpc-server-microservice.yaml

kubectl get services
kubectl get deployment
kubectl get pods



