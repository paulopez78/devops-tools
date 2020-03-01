#!/bin/bash

# Get all keys and values from etcd db
KEY=${KEY:-"/registry/pods/votingapp/votingapp"}
kubectl exec \
-n kube-system \
etcd-docker-desktop -- \
sh -c "ETCDCTL_API=3 etcdctl \
--cacert=/run/config/pki/etcd/ca.crt \
--cert=/run/config/pki/etcd/healthcheck-client.crt \
--key=/run/config/pki/etcd/healthcheck-client.key \
get \"$KEY\" \
--prefix=true -w json" | jq -r '.kvs[0].value' | base64 --decode

