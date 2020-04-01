# container-hello-world-html-busybox

## Loop

```shell
bump patch
build.sh
commit.sh
release.sh
```


## Helm Building

```shell
$> helm lint charts/hello-world/
==> Linting charts/hello-world/
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, no failures

[hello-world/charts/hello-world]$>  helm package . -d ../../chartsbins/ --debug
Successfully packaged chart and saved it to: ../../chartsbins/hello-world-0.1.4.tgz
[debug] Successfully saved ../../chartsbins/hello-world-0.1.4.tgz to /Users/scottmacgregor/.helm/repository/local
```

## Observe the LoadBalancer Installed

```
helm install ./chartbins/hello-world-0.1.2.tgz --name hw
kubectl get svc --watch # wait for a IP
```

```shell
_hello_world_svc=$(kubectl get svc --namespace default hw-hello-world --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
curl -s "http://$_hello_world_svc"
```

### Helm Inspect

`helm inspect values hello-world-chart`

this will dump the `values.yaml`

### Output

```shell
NAME:   hw
LAST DEPLOYED: Wed Mar 11 13:38:38 2020
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME             AGE
hw-hello-world  0s

==> v1/Pod(related)
NAME                             AGE
hw-hello-world-77469c4c5-gbfch  0s

==> v1/Service
NAME             AGE
hw-hello-world  0s

==> v1/ServiceAccount
NAME             AGE
hw-hello-world  0s


NOTES:
1. Get the application URL by running these commands:
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get --namespace default svc -w helloworld-hello-world-chart'
  export SERVICE_IP=$(kubectl get svc --namespace default helloworld-hello-world-chart --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo http://$SERVICE_IP:80
```

```shell
helm ls --all helloworld
NAME      	REVISION	UPDATED                 	STATUS	CHART                  	APP VERSION	NAMESPACE
helloworld	1       	Mon Mar  9 16:55:39 2020	FAILED	hello-world-chart-0.1.0	1.0        	default
```

### ELB Configure Correctly

```shell
Name:                     hw-hello-world
Namespace:                default
Labels:                   app.kubernetes.io/instance=hw
                          app.kubernetes.io/managed-by=Tiller
                          app.kubernetes.io/name=hello-world
                          app.kubernetes.io/version=1.0
                          helm.sh/chart=hello-world-0.1.4
Annotations:              <none>
Selector:                 app.kubernetes.io/instance=h-w,app.kubernetes.io/name=hello-world
Type:                     LoadBalancer
IP:                       10.255.46.62
LoadBalancer Ingress:     172.17.1.201
Port:                     http  80/TCP
TargetPort:               8005/TCP
NodePort:                 http  32052/TCP
Endpoints:                10.254.207.226:8005
Session Affinity:         None
External Traffic Policy:  Cluster
Events:
  Type    Reason        Age                  From                Message
  ----    ------        ----                 ----                -------
  Normal  IPAllocated   13m                  metallb-controller  Assigned IP "172.17.1.201"
  Normal  nodeAssigned  3m33s (x3 over 13m)  metallb-speaker     announcing from node "konvoy-docker-worker-pool0-0"
```

## Errors / Tweaks

Telling helm to package the output into a subdirectory will cause a recursive package. Even worse if you put the `tgz` into charts it will treat itself as dependency causing a bomb failure.

Also Helm had issues as it created a readiness and liveliness probe by default. This is important, but it needs to be disabled in the `deployment.yaml` for `hello-world`.  Note, we could change it to check for correct port etc..

### ELB **Not** configured correctly

* Note the default template messed up and didnt work with `TargetPort`

```shell
kubectl describe service helloworld
Name:                     helloworld-hello-world-chart
Namespace:                default
Labels:                   app.kubernetes.io/instance=helloworld
                          app.kubernetes.io/managed-by=Tiller
                          app.kubernetes.io/name=hello-world-chart
                          app.kubernetes.io/version=1.0
                          helm.sh/chart=hello-world-chart-0.1.1
Annotations:              <none>
Selector:                 app.kubernetes.io/instance=helloworld,app.kubernetes.io/name=hello-world-chart
Type:                     LoadBalancer
IP:                       10.0.58.97
LoadBalancer Ingress:     ae01ed9ea49c54ee9b32fd9f96a7ba8a-1516296865.us-west-2.elb.amazonaws.com
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  32550/TCP
Endpoints:
Session Affinity:         None
External Traffic Policy:  Cluster
Events:
  Type    Reason                Age    From                Message
  ----    ------                ----   ----                -------
  Normal  EnsuringLoadBalancer  6m16s  service-controller  Ensuring load balancer
  Normal  EnsuredLoadBalancer   6m14s  service-controller  Ensured load balancer
  ```

## Cleanup

### Remove created docker images

```
docker images # list images
docker rmi hello-world
```

Reference: https://docs.docker.com/config/pruning/

### Remove created helm packages

```
helm delete helloworld
helm delete --purge helloworld
```

Reference: https://v2.helm.sh/docs/using_helm/#helm-delete-deleting-a-release

# Reference

https://v2.helm.sh/docs/using_helm/#helm-repo-working-with-repositories  
https://docs.microsoft.com/en-us/azure/container-registry/container-registry-helm-repos#use-the-helm-2-client  
