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
:
:
helm install helloworld-chart-0.1.0.tgz --name helloworld
kubectl get svc --watch # wait for a IP
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
