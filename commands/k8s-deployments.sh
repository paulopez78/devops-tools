#!/bin/bash

# rolling update with one pod
kubectl run votingapp --image=paulopez/votingapp:0.1-alpine --generator=run-pod/v1
kubectl expose pod votingapp --port=8080 --target-port 5000 --type NodePort

kubectl run votingapp-beta --image=paulopez/votingapp:0.2-alpine --generator=run-pod/v1
kubectl label votingapp-beta run=votingapp --overwrite
kubectl label votingapp run=votingapp-legacy --overwrite

# rolling update with failing probe
kubectl apply -f votingapp-pod-readiness-probe.yaml

# get access to the service or pod with port-forward (for troubleshooting)
kubectl port-forward svc/votingapp 8080:8080
kubectl port-forward pod/votingapp 8080:5000

# blue green with one pod
kubectl run votingapp --image=paulopez/votingapp:0.1-alpine --generator=run-pod/v1
kubectl run votingapp-beta --image=paulopez/votingapp:0.2-alpine --generator=run-pod/v1
kubectl patch svc votingapp -p '{"spec":{"selector":{"run":"votingapp-beta"}}}'                     


# create a deployment yaml resource
kubectl create deployment nginx --image nginx --dry-run --output yaml
kubectl run nginx --image nginx --dry-run --expose --port 8080 --output yaml
kubectl get deployment nginx --output yaml --export > mynginx.yaml

# Track changes when changing resources
kubectl replace --save-config
kubectl apply view-last-applied deployments nginx -o yaml
kubectl apply -f xxx --server-dry-run
kubectl diff -f some-resources.yaml
kubectl logs --tail=1