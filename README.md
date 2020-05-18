# playhrzn-k8s

## Pomerium

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

