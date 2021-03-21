#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

need "kubectl"

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

kapply() {
  if output=$(envsubst < "$@"); then
    printf '%s' "$output" | kubectl apply -f -
  fi
}

installManualObjects(){
  . "$REPO_ROOT"/setup/.env

  message "installing manual secrets and objects"

  ##########
  # secrets
  ##########
  kubectl -n kube-system create secret generic kms-vault --from-literal=account.json="$(echo $VAULT_KMS_ACCOUNT_JSON | base64 --decode)"
  kubectl -n kube-system create secret generic hcloud-api-token --from-literal=token="$HC_API_TOKEN"

  
  ##########
  # crds
  ##########
  kustomize build ../cert-manager/crds > /tmp/build.yaml
  kustomize build ../monitoring/kube-prometheus-stack/crds >> /tmp/build.yaml
  cat ../kube-system/vault-secrets-operator/crd.yaml >> /tmp/build.yaml
  kubectl apply -f /tmp/build.yaml && rm -f /tmp/build.yaml
}

installManualObjects

message "all done!"
