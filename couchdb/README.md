# CouchDB

Apache CouchDB is a database featuring seamless multi-master sync, that scales
from big data to mobile, with an intuitive HTTP/JSON API and designed for
reliability.

This chart deploys a CouchDB cluster as a StatefulSet. It creates a ClusterIP
Service in front of the Deployment for load balancing by default, but can also
be configured to deploy other Service types or an Ingress Controller. The
default persistence mechanism is simply the ephemeral local filesystem, but
production deployments should set `persistentVolume.enabled` to `true` to attach
storage volumes to each Pod in the Deployment.

## TL;DR

```bash
$ helm repo add couchdb https://apache.github.io/couchdb-helm
$ helm install couchdb/couchdb --set allowAdminParty=true
```

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

Add the CouchDB Helm repository:

```bash
$ helm repo add couchdb https://apache.github.io/couchdb-helm
```


```bash
$ helm install --name my-release couchdb/couchdb
```

This will create a Secret containing the admin credentials for the cluster.
Those credentials can be retrieved as follows:

```bash
$ kubectl get secret my-release-couchdb -o go-template='{{ .data.adminPassword }}' | base64 --decode
```

If you prefer to configure the admin credentials directly you can create a
Secret containing `adminUsername`, `adminPassword` and `cookieAuthSecret` keys:

```bash
$  kubectl create secret generic my-release-couchdb --from-literal=adminUsername=foo --from-literal=adminPassword=bar --from-literal=cookieAuthSecret=baz
```

and then install the chart while overriding the `createAdminSecret` setting:

```bash
$ helm install --name my-release --set createAdminSecret=false couchdb/couchdb
```

This Helm chart deploys CouchDB on the Kubernetes cluster in a default
configuration. The [configuration](#configuration) section lists
the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` Deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Upgrading an existing Release to a new major version

A major chart version change (like v0.2.3 -> v1.0.0) indicates that there is an
incompatible breaking change needing manual actions.

## Migrating from stable/couchdb

This chart replaces the `stable/couchdb` chart previously hosted by Helm and continues the
version semantics. You can upgrade directly from `stable/couchdb` to this chart using:

```bash
$ helm repo add couchdb https://apache.github.io/couchdb-helm
$ helm upgrade my-release couchdb/couchdb
```

## Configuration

The following table lists the most commonly configured parameters of the
CouchDB chart and their default values:

|           Parameter             |             Description                               |                Default                 |
|---------------------------------|-------------------------------------------------------|----------------------------------------|
| `clusterSize`                   | The initial number of nodes in the CouchDB cluster    | 3                                      |
| `couchdbConfig`                 | Map allowing override elements of server .ini config  | chttpd.bind_address=any                |
| `allowAdminParty`               | If enabled, start cluster without admin account       | false (requires creating a Secret)     |
| `createAdminSecret`             | If enabled, create an admin account and cookie secret | true                                   |
| `schedulerName`                 | Name of the k8s scheduler (other than default)        | `nil`                                  |
| `erlangFlags`                   | Map of flags supplied to the underlying Erlang VM     | name: couchdb, setcookie: monster
| `persistentVolume.enabled`      | Boolean determining whether to attach a PV to each node | false
| `persistentVolume.size`         | If enabled, the size of the persistent volume to attach                          | 10Gi
| `enableSearch`                  | Adds a sidecar for Lucene-powered text search         | false                                  |

A variety of other parameters are also configurable. See the comments in the
`values.yaml` file for further details:

|           Parameter             |                Default                 |
|---------------------------------|----------------------------------------|
| `adminUsername`                 | admin                                  |
| `adminPassword`                 | auto-generated                         |
| `cookieAuthSecret`              | auto-generated                         |
| `image.repository`              | couchdb                                |
| `image.tag`                     | 2.3.1                                  |
| `image.pullPolicy`              | IfNotPresent                           |
| `searchImage.repository`        | kocolosk/couchdb-search                |
| `searchImage.tag`               | 0.1.0                                  |
| `searchImage.pullPolicy`        | IfNotPresent                           |
| `initImage.repository`          | busybox                                |
| `initImage.tag`                 | latest                                 |
| `initImage.pullPolicy`          | Always                                 |
| `ingress.enabled`               | false                                  |
| `ingress.hosts`                 | chart-example.local                    |
| `ingress.path`                  | /                                      |
| `ingress.annotations`           |                                        |
| `ingress.tls`                   |                                        |
| `persistentVolume.accessModes`  | ReadWriteOnce                          |
| `persistentVolume.storageClass` | Default for the Kube cluster           |
| `podManagementPolicy`           | Parallel                               |
| `affinity`                      |                                        |
| `annotations`                   |                                        |
| `resources`                     |                                        |
| `service.annotations`           |                                        |
| `service.enabled`               | true                                   |
| `service.type`                  | ClusterIP                              |
| `service.externalPort`          | 5984                                   |
| `dns.clusterDomainSuffix`       | cluster.local                          |


## Feedback, Issues, Contributing

General feedback is welcome at our [user][1] or [developer][2] mailing lists.

Apache CouchDB has a [CONTRIBUTING][3] file with details on how to get started
with issue reporting or contributing to the upkeep of this project. In short,
use GitHub Issues, do not report anything on Docker's website.

## Non-Apache CouchDB Development Team Contributors

- [@natarajaya](https://github.com/natarajaya)
- [@satchpx](https://github.com/satchpx)
- [@spanato](https://github.com/spanato)
- [@jpds](https://github.com/jpds)
- [@sebastien-prudhomme](https://github.com/sebastien-prudhomme)
- [@stepanstipl](https://github.com/sebastien-stepanstipl)
- [@amatas](https://github.com/amatas)
- [@Chimney42](https://github.com/Chimney42)
- [@mattjmcnaughton](https://github.com/mattjmcnaughton)
- [@mainephd](https://github.com/mainephd)
- [@AdamDang](https://github.com/AdamDang)
- [@mrtyler](https://github.com/mrtyler)

[1]: http://mail-archives.apache.org/mod_mbox/couchdb-user/
[2]: http://mail-archives.apache.org/mod_mbox/couchdb-dev/
[3]: https://github.com/apache/couchdb/blob/master/CONTRIBUTING.md
