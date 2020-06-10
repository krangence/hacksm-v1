# K8s-Flux

Below is an overview of what is contained within this repo, such as the various application configurations and kubernetes specific settings like _kube-system_.

## _Elastic-Stack_
This contains the following applications & Configurations

elasticsearch, filebeat, kibana, logstash, metricbeat.

## _External-DNS_

_Documentation In-progress_

## _Forecastle_
Application Control Pannel, used for accessing all applications used within the cluster.

## _Ingress-nginx_

_Documentation In-progress_

## _Kong_

API / Endpoint System used in the cluster for personal projects

## _kube-system_

_Documentation In-progress_


## _kubernetes-dashboard_

_Documentation In-progress_

## _Monitoring_

Monitoring configuration for the cluster once deployed. Shows pod allocation and services contained within each pod. _**Note**_:  All kube system specific items required per deployed pod will also be shown on this monitoring screen for the cluster. 

The code block below is an example representation / reference to _**hostname:**_ which needs to be updated as required.

```
 ingress:
      enabled: true
      hostname: ops.hacksm.net
      annotations:
        ingress.pomerium.io/allowed_users: '["**Enter Email Here**"]'
        ingress.pomerium.io/allow_websockets: "true"
        forecastle.stakater.com/expose: "true"
        forecastle.stakater.com/appName: "Kube Ops View"
        forecastle.stakater.com/icon: https://hub.helm.sh/api/chartsvc/v1/assets/stable/kube-ops-view/logo
```

## _Namespaces_

This specific area contains all the namespace references wthat are used within the repo, for the various applications and system specific items.

The code block below is an example representation / reference to _**name:**_ where the namespace is referenced within the configuration:

```---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/name: alb-ingress-controller
  name: alb-ingress-controller```

## _Pomerium_

[Pomerium](pomerium/pomerium) is declared as a [HelmRelease](https://docs.fluxcd.io/projects/helm-operator/en/latest/references/helmrelease-custom-resource/) [here](./base/pomerium/helm-release.yaml).

Any secret values required by this deployment are sealed and declared as a [SealedSecret](https://github.com/bitnami-labs/sealed-secrets) [here](./base/pomerium/sealed-secret.yaml). The [Helm Operator](https://github.com/fluxcd/helm-operator) consumes and merges the secret with the values declared in the HelmRelease.

The following code block is a representation of the secret:
```yaml
config:
  sharedSecret: $(head -c32 /dev/urandom | base64)
  cookieSecret: $(head -c32 /dev/urandom | base64)
authenticate:
  idp:
    provider: google
    url: https://accounts.google.com
    clientID: ${OAUTH_CLIENT_ID}.apps.googleusercontent.com
    clientSecret: ${OAUTH_CLIENT_SECRET}
    serviceAccount: $(jq -r '. += {"impersonate_user": "admin@example.com"} | @base64')
```

