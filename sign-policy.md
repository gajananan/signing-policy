# How to sign YAML resources in policy-collection 

 Policies in https://github.com/open-cluster-management/policy-collection

### Signing key Type
`pgp`: use [gpg key](https://www.gnupg.org/index.html) for signing.


### GPG Key Setup

First, you need to setup GPG key/

If you do not have any PGP key or you want to use new key, generate new one and export it to a file. See [this GitHub document](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-gpg-key).

The following example shows how to generate GNUPG key (with your email address e.g. signer@enterprise.com)

```
gpg --full-generate-key

```

Confirm if key is avaialble in keyring

```
gpg -k signer@enterprise.com
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
pub   rsa2048 2020-01-27 [SC]
      9D96363D64B579F077AD9446D57583E19B793A64
uid           [ultimate] Signer <signer@enterprise.com>
sub   rsa2048 2020-01-27 [E]

```

```
$ git clone https://github.com/IBM/integrity-enforcer.git
$ cd integrity-enforcer
$ pwd /home/repo/integrity-enforcer
$ export IE_REPO_ROOT=/home/repo/integrity-enforcer

```




Sample script `generatio_annotation.sh` to apply signature annotations on YAML resources in a directory.


```
#!/bin/bash

signer = $1
dir = $2

find $dir -type f -name "*.yaml" | while read file;
do
  echo Signing  $file
  $IE_REPO_ROOT/scripts/gpg-annotation-sign.sh $signer "$file"
done
```

Invoke above scripts as below


```
$./generate_annot.sh signer@enterprise.com <YAML-RESOURCES=DIRECTORY>
```






