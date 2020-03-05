# Session 5: Kubernetes pods, replicasets and services

- Local kubernetes setup with docker for desktop or minikube.
- Kubectl autocomplete, ohmyzsh plugin and kubectx.
- Kubectl config.
- Create and run pods with kubectl, imperative way.
- Inspect pod resource with describe command.
- Export pod to a yaml file and create it declarative way.
- Multiple containers in a pod sharing a volume, sidecar container pattern.
- Pods lifecycle, failing containers and probes.
- ReplicationController and Replicasets

All the `kubectl` examples are in the file `k8s-pods.sh`

# Session 6: Kubernetes services and deployments

- Expose pod and replicaset with a service, explaining service selector.
- ClusterIp, NodePort, LoadBalancer services types.
- Kube DNS and services environment variables.
- Endpoints and readiness probes.
- Rolling updates examples with naked pods, replicasets and deployments.
- maxSurge, minUnavailable, revisionHistoryLimit and minReadySeconds

All the `kubectl` examples are in `k8s-network.sh` and `k8s-deployments.sh`

# Session 7: Kubernetes ingress, configmaps and secrets
- Install nginx ingress controller (docker for deskop or minikube)
- Add votingapp ingress to configure nginx automatically.
- Install traefik ingress controller.
- Multiple ingress controllers using ``kubernetes.io/ingress.class`` annotation.

# Session 8: Kubernetes storage and statefulsets
- PersistentVolumes, PersistentVolumeClaims
- StorageClass
- StatefulSets and Headless services.
- StatefulSets with PersistentVolumeClaims, PersistentVolumes and StorageClass.
