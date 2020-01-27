#!/bin/bash

docker-compose rm -f && \
docker-compose up --build -d && \
docker-compose run --rm mytest && \
docker-compose push && \
kubectl apply -f ./k8s && \
kubectl run mytests \
    --generator=run-pod/v1 \
    --image=paulopez/votingapp-test \
    --env VOTINGAPP_HOST=myvotingapp \
    --rm --attach --restart=Never && \
echo "GREEN" || echo "RED"

# ns="votingapp"
# kubectl delete namespace $ns && kubectl create namespace  $ns
# # kubectl run myvotingapp --image=paulopez/votingapp --env REDIS=myredis:6379 -n $ns
# # kubectl run myredis --image=redis -n $ns
# # kubectl expose deployment myvotingapp --port=80 --target-port=80 --type NodePort -n $ns
# # kubectl expose deployment myredis --port=6379 --target-port=6379 -n $ns
# kubectl apply -f ./k8s

# echo "GREEN" || echo "RED"