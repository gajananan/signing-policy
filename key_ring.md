# How to deploy verification key to managed cluster


## Verification key Type
`pgp`: use [gpg key](https://www.gnupg.org/index.html) for signing.



### GPG Key Setup

First, you need to export public key to a file. The following example shows a pubkey for a signer identified by an email `signer@enterprise.com` is exported and stored in `/tmp/pubring.gpg`. (Use the filename `pubring.gpg`.)

```
$ gpg --export signer@enterprise.com > /tmp/pubring.gpg
```

If you do not have any PGP key or you want to use new key, generate new one and export it to a file. See [this GitHub document](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-gpg-key).

### Prepare yaml

The following is a sample content of resources.yaml which are required to create verification key in managed cluster.

1.  Change <TARGET NAMESPACE> 
    Set the namespace where integrity enforcer would be deployed in managed cluster
        
2.  Change <INSERT ENCODED PUBRING KEY HERE>
    Set the encoded content of /tmp/pubring.gpg
        
To get the encoded content:

```  
$ cat /tmp/pubring.gpg | base64
```    
        
        
        
```
apiVersion: v1
kind: Namespace
metadata:
  name: <TARGET NAMESPACE>
---
apiVersion: v1
data:
  pubring.gpg: <INSERT ENCODED PUBRING KEY HERE>
kind: Secret
metadata:
  annotations:
    apps.open-cluster-management.io/deployables: "true"
  name: keyring-secret
  namespace: <TARGET NAMESPACE>
type: Opaque
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: keyring-secret-deployments
  namespace: <TARGET NAMESPACE>
spec:
  pathname: <TARGET NAMESPACE>
  sourceNamespaces:
  - <TARGET NAMESPACE>
  type: Namespace
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: secret-placement
  namespace: <TARGET NAMESPACE>
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
  namespace: <TARGET NAMESPACE>
spec:
  channel: <TARGET NAMESPACE>/keyring-secret-deployments
  placement:
    placementRef:
      kind: PlacementRule
      name: secret-placement
```



