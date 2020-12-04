#!/bin/bash
CMDNAME=`basename $0`
if [ $# -ne 2 ]; then
  echo "Usage: $CMDNAME <NAMESPACE> <PUBRING-KEY> " 1>&2
  exit 1
fi

if ! [ -x "$(command -v kubectl)" ]; then
    echo 'Error: kubectl is not installed.' >&2
    exit 1
fi

NAMESPACE=$1
PUBRING_KEY=$2

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BASE='base64 -w 0'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    BASE='base64'
fi

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
---
apiVersion: v1
data:
  pubring.gpg: `echo ${PUBRING_KEY}`
kind: Secret
metadata:
  annotations:
    apps.open-cluster-management.io/deployables: "true"
  name: keyring-secret
  namespace: ${NAMESPACE}
type: Opaque
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: keyring-secret-deployments
  namespace: ${NAMESPACE}
spec:
  pathname: ${NAMESPACE}
  sourceNamespaces:
  - ${NAMESPACE}
  type: Namespace
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: secret-placement
  namespace: ${NAMESPACE}
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions:
    - key: environment
      operator: In
      values:
      - dev
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: keyring-secret
  namespace: ${NAMESPACE}
spec:
  channel: ${NAMESPACE}/keyring-secret-deployments
  placement:
    placementRef:
      kind: PlacementRule
      name: secret-placement
EOF
