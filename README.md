# pxup

Bring up a Portworx cluster using Vagrant and libvirt based on docker. It also installs a minio server on each
node on port 7999 with access_key `admin` and secret_key `password`.

To use with sdk-test:

```yaml
cloudproviders:
  aws:
    CredName: "minio"
    CredType: "s3"
    CredRegion: "us-east-1"
    CredAccessKey: "admin"
    CredEndpoint: "NODEIPHERE:7999"
    CredSecretKey: "password"
    CredDisableSSL: "true"
```

# Usage

* One time setup: `make bootstrap` which installs needed dependencies for your vagrant installation (ot doesn't install Vagrant itself)
* One time config generation `make config-init`
* Set the name and tag of your image, VMs name prefix, network range, etc... at `global_vars.yaml`

### Build the cluster

* Run `make up` and enjoy

### Redeploy

Once the system is running, to redeploy a new version type:

```
$ make update
```

# Infrastructure

To increase the number of nodes, disks, or memory, etc... edit the corresponded value
in the global_vars.yml:

```
prefix: dmts
nodes: 3
disks: 3
memory: 8192
cpus: 2
private_network_prefix: '192.168.30.10'
pximage: quay.io/porx/porxsdkdmts:1
pullimage: false
oci: true
auth: false
oci_switches: -enable-shared-v4
shared_secret: mysecret
cache: true
```

