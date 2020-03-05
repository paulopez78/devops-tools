#!/bin/bash

kubectl create deployment mongo --image mongo
kubectl get storageclass

# Basic mongo shell commands
# https://docs.mongodb.com/manual/reference/mongo-shell/
# use votingapp
# db.votes.findOne()

# can't scale stateful pods using the same volume
kubectl scale deployment mongo --replicas 2
kubectl apply -f k8s/mongo-statefulset.yaml

# check headless service (no cluster IP) and endpoints
kubectl get service mongo
kubectl get endpoints mongo
kubectl run tools \
    --generator=run-pod/v1 \
    --attach  --rm --restart=Never \
    --image=tutum/dnsutils -- nslookup mongo

# build a mongo cluster with an statefulset and sidecontainer
kubectl apply -f k8s/mongo-cluster.yaml

# checking logs of sidecontainer
kubectl logs mongo-0 -c mongo-sidecar
kubectl exec -it mongo-0 -c mongo -- mongo