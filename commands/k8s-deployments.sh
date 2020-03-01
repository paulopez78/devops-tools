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

# rolling update with replicate sets
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  labels:
    app: votingapp
  name: votingapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: votingapp
      deployment: votingapp-1
  template:
    metadata:
      labels:
        app: votingapp
        deployment: votingapp-1
    spec:
      containers:
        - image: paulopez/votingapp:0.1-alpine
          name: votingapp
EOF

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  labels:
    app: votingapp-beta
  name: votingapp-beta
spec:
  replicas: 0
  selector:
    matchLabels:
      app: votingapp
      deployment: votingapp-2
  template:
    metadata:
      labels:
        app: votingapp
        deployment: votingapp-2
    spec:
      containers:
        - image: paulopez/votingapp:0.2-alpine
          name: votingapp
EOF

kubectl scale rs votingapp-beta --replicas 1
kubectl scale rs votingapp --replicas 2

# create a deployment yaml resource
kubectl create deployment votingapp --image paulopez/votingapp:0.1-alpine --dry-run --output yaml
kubectl expose deployment votingapp --port=8080 --target-port 5000 --type NodePort

kubectl set image deployment votingapp votingapp=paulopez/votingapp:0.2-alpine
kubectl rollout status deployment votingapp
kubectl rollout undo deployment votingapp


# Track changes when changing resources
kubectl replace --save-config
kubectl apply view-last-applied deployments nginx -o yaml
kubectl apply -f xxx --server-dry-run
kubectl diff -f some-resources.yaml
kubectl logs --tail=1