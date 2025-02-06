#!/usr/bin/env bash

set -euo pipefail

if [[ -z $1 ]]; then
  echo "Usage: nodeshell <node>"
  exit 1
fi

node=${1}
nodeName=$(
  kubectl get node "${node}" \
    -o template \
    --template='{{index .metadata.labels "kubernetes.io/hostname"}}'
)
nodeSelector='"nodeSelector": { "kubernetes.io/hostname": "'${nodeName:?}'" },'
uuid=$(cat /proc/sys/kernel/random/uuid)
podName=nsenter-${node}-${uuid%%-*}

kubectl run "${podName:?}" --restart=Never -it --rm --image overriden --overrides '
{
  "spec": {
    "hostPID": true,
    "hostNetwork": true,
    '"${nodeSelector?}"'
    "tolerations": [{
        "operator": "Exists"
    }],
    "containers": [
      {
        "name": "'"${podName}"'",
        "image": "alexeiled/nsenter:2.34",
        "command": [
          "/nsenter", "--all", "--target=1", "--", "bash", "-i"
        ],
        "stdin": true,
        "tty": true,
        "securityContext": {
          "privileged": true
        }
      }
    ]
  }
}' --attach "$@"
