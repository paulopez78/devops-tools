#!/bin/bash

# create a pod for votingapp with run and export yaml
kubectl create namespace votingapp
kubectl run votingapp --generator=run-pod/v1 --image=votingapp
kubectl get pods votingapp -o yaml > k8s/votingapp.yaml

# make a request from other pod or from the node (ssh into machine)
minikube ssh
kubectl run test --generator=run-pod/v1 --image=paulopez/kurl -- sleep infinity
votingapp_ip=$(kubectl get pods votingapp -o wide --no-headers | awk '{ print $6}')
kubectl exec -it test -- curl http://$votingapp_ip:5000
kubectl run test \
    --generator=run-pod/v1 \
    --image=paulopez/votingapp-test:alpine \
    --restart=Never \
    --env VOTING_URL=http://$votingapp_ip:5000

# run the test removing the pod after completion
kubectl run test \
    --generator=run-pod/v1 \
    --image=paulopez/votingapp-test:alpine \
    --restart=Never \
    --env VOTING_URL=http://$votingapp_ip:5000 \
    --rm --attached

# test the solution using kind (with more than one worker node)
kind create cluster --config kind/kind.yaml

# expose a pod with a service

# connect to a k8s worker and check iptables rules
docker exec -it kind-worker bash  
iptables -t nat -L | grep votingapp