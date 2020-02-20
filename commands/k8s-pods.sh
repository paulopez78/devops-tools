#!/bin/bash

# manage the connection to a cluster with config
cat ${HOME}/.kube/config
kubectl version
kubectl config get-contexts
kubectl config current-context
kubectl config use-context docker-desktop 

# setup auto completion
kubectl completion -h

# get cluster nodes
kubectl get nodes
kubectl cluster-info
kubectl get componentstatuses
kubectl api-resources

# get namespaces
kubectl get ns

# create/running/describe/delete pods
kubectl run test-proxy --generator=run-pod/v1 --image=nginx
kubectl get pods -o wide  
kubectl get all
kubectl logs test-proxy
kubectl describe pod test-proxy  
kubectl exec -it test-proxy -- bash
# into the container install tools
apt-get update && apt-get install procps curl -y

kubectl delete pod test-proxy
kubectl create ns workshop
kubectl config set-context --namespace workshop --current
#kubens is doing something like that simple alias
alias kgn='kubectl config set-context --current --namespace'
kubens workshop

# export pod yaml
kubectl get pod test-proxy -o yaml > test-proxy.yaml
kubectl explain

# labels
kubectl get pods --show-labels
kubectl get pods -L env,app
kubectl get pods -l env,app

# add kurl container and volume
kubectl logs test-proxy -c test-proxy -f
kubectl exec -it test-proxy -c kurl -- localhost

# pod restart containers when killed and watch results
kurl_container_id=$(docker ps | grep kurl_test-proxy | awk '{ print $1 }')
kubectl get pods --watch
docker rm -f $kurl_container_id

# update with a correct/incorrect image and diff before applying
kubectl diff -f test-proxy.yaml
kubectl apply -f --dry-run test-proxy.yaml
kubectl apply -f --server-dry-run test-proxy.yaml
kubectl apply -f test-proxy.yaml