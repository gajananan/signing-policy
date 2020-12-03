
# How to install Integrity Verifier using the GRC policy

## 

This section describe the steps for deploying Integrity Verifier (IV) on your managed cluster via GRC policy.

1. Retrive the source from `policy-collection` Git repository.

    git clone this repository and moved to `policy-collection` directory

    ```
    $ git clone https://github.com/open-cluster-management/policy-collection.git
    $ cd policy-collection
    $ pwd /home/repo/policy-collection
    ```
    In this document, we clone the code in `/home/repo/policy-collection`.
    
  
2. Setup a verification key in a managed cluster(s).

   Refer this document to for propagating a verification key from an ACM hub cluster to a managed cluster.

3. Prepare `CatalogSource` in a managed cluster (s) to bring Integrity Verifier Operator in OperatorHub of a managed cluster(s)

    The following shows a sample `catalog_source.yaml`
    
    ```
    apiVersion: operators.coreos.com/v1alpha1
    kind: CatalogSource
    metadata:
      name: integrity-operator-catalog
      namespace: "openshift-marketplace"
    spec:
      sourceType: grpc
      image: quay.io/open-cluster-management/integrity-verifier-operator-index:0.0.4
      displayName: "TRL Test Operators"
      publisher: "IBM"
      updateStrategy:
        registryPoll:
          interval: 1m
      ```
      
      The following command would create a CatalogSource in a cluster
      ```
      oc apply -f catalog_source.yaml --validate=false
      ```
      This will setup Integrity Verifier Operator in OperatorHub of the cluster.
      
      
4.  Prepare a namespace to deploy Policies in a ACM hub cluster. 

    The following command uses `policies` as default namespace for creating policies in a ACM hub cluster. 
    ```
    oc create ns polices 
    
    ```
    We switch to `polices` namespace.
    ```
    oc project polices
    ```        
    
    The following command deploys polices under `community` to an ACM hub cluster.
      
    ```
    $ cd policy-collection/deploy
    $ bash ./deploy.sh https://github.com/open-cluster-management/policy-collection.git community policies
    ```
      
10. Confirm if `integrity-verifier` is running successfully in a managed cluster.
    
    Check if there are two pods running in the namespace `integrity-verifier-operator-system`: 
        
    ```
    $ oc get pod -n integrity-verifier-operator-system
    integrity-verifier-operator-c4699c95c-4p8wp   1/1     Running   0          5m
    integrity-verifier-server-85c787bf8c-h5bnj    2/2     Running   0          82m
    ```      
    
    
## 
