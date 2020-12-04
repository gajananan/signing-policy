#!/bin/bash
if [ -z "$IV_NS" ]; then
    echo "IV_NS is empty. Please set"
    exit 1
fi

cat <<EOF | kubectl apply -n $IV_NS -f -
apiVersion: v1
kind: Secret
metadata:
  name: keyring-secret
type: Opaque
data:
  pubring.gpg: `cat /tmp/pubring.gpg | base64 -w 0`
EOF
