#!/bin/bash
kubectl get componentstatuses

# completion
kubectl completion -h
kubectl api-resources

# create a deployment yaml resource

kubectl create deployment nginx --image nginx --dry-run --output yaml
kubectl run nginx --image nginx --dry-run --expose --port 8080 --output yaml

kubectl get deployment nginx --output yaml --export > mynginx.yaml

# kubectl explain command
kubectl explain

# Track changes when changing resources
kubectl replace --save-config
kubectl apply view-last-applied deployments nginx -o yaml
kubectl apply -f xxx --server-dry-run
kubectl diff -f some-resources.yaml


kubectl logs --tail=1