# container-hello-world-html-busybox

## Loop

```shell
bump patch
build.sh
commit.sh
release.sh
```


## Helm

```shell
helm lint hello-world-chart/
helm package helloworld-chart --debug
```
## Observe
```
helm install helloworld-chart-0.1.0.tgz --name helloworld
kubectl get svc --watch # wait for a IP
```

### Output

```shell
helm install hello-world-chart-0.1.1.tgz --name helloworld
NAME:   helloworld
LAST DEPLOYED: Mon Mar  9 21:30:27 2020
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME                          AGE
helloworld-hello-world-chart  0s

==> v1/Pod(related)
NAME                                           AGE
helloworld-hello-world-chart-59f75b7f75-qjmq2  0s

==> v1/Service
NAME                          AGE
helloworld-hello-world-chart  0s

==> v1/ServiceAccount
NAME                          AGE
helloworld-hello-world-chart  0s


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

### ELB Not configured correctly

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

### Remove created helm packages

```
helm delete helloworld
helm delete --purge helloworld
```
