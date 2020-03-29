#!/bin/bash

docker build -t paulopez/tools ./tools
docker push paulopez/tools

kubectl delete pod tools
kubectl apply -f ./k8s/tools.yml
kubectl wait --for=condition=Ready pod/tools
kubectl exec -it tools -- sh