# How to deploy verification key to managed cluster


## Verification key Type
`pgp`: use [gpg key](https://www.gnupg.org/index.html) for signing.



### GPG Key Setup

First, you need to export public key to a file. The following example shows a pubkey for a signer identified by an email `signer@enterprise.com` is exported and stored in `/tmp/pubring.gpg`. (Use the filename `pubring.gpg`.)

```
$ gpg --export signer@enterprise.com > /tmp/pubring.gpg
```

If you do not have any PGP key or you want to use new key, generate new one and export it to a file. See [this GitHub document](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-gpg-key).


### Deploy verification key to hub cluster so that it can probagate to managed cluster
```
$ cd scripts
$ ./probagate-keyring.sh integrity-verifier-operator-system $(cat /tmp/pubring.gpg | base64 -w 0)
```


Pass two parameters 
1.  Namespace

    `integrity-verifier-operator-system`  is the target namespace where verification key would be created in managed cluster. 
     (the namespace where integrity enforcer would be deployed in managed cluster)
        
2.  Verification key 

    Pass the encoded content of /tmp/pubring.gpg : `$(cat /tmp/pubring.gpg | base64 -w 0)`
        
