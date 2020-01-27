ns="mdas"

kubectl delete namespace $ns 
kubectl create namespace $ns 

kubectl config set-context --namespace $ns --current

kubectl run mynginx --generator=run-pod/v1 --image=nginx  -n $ns
kubectl expose pod mynginx --port=80 --target-port=80 --type NodePort -n $ns

 kubectl describe pod mynginx -n $ns
 kubectl run tools --generator=run-pod/v1 -it --rm --image=paulopez/kurl -- bash 
 kubectl exec tools -it -- bash 

kubectl apply -f nginx.yml