# CouchDB Helm Charts

This repository contains assets related to the CouchDB Helm chart.

## Layout

 * `couchdb`: contains the unbundled Helm chart
 * `test`: containes scripts to test the chart locally using [Kind][5]

## Testing

`make test` will run an integration test using [Kind][5]. This stands up a Kubernetes cluster locally and ensures the chart will
deploy using the default options and Helm.

## Releasing

The Helm chart is published to a Helm epository hosted by GitHub pages. This is maintained in the `gh-pages` branch of this repository.

To publish a new release, perform the following steps:

 1. Create a Helm bundle (*.tgz) for the current couchdb chart
 2. Switch to the `gh-pages` branch
 3. Run `helm repo index docs --url https://apache.github.io/couchdb-helm` to generate the Helm repository index
 4. `git add` the tgz bundle and the `index.yaml` files. Do not delete the old chart bundles!
 5. Commit the changes and create a PR to `gh-pages`.

`make publish` automates these steps for you.

## Feedback / Issues / Contributing

General feedback is welcome at our [user][1] or [developer][2] mailing lists.

Apache CouchDB has a [CONTRIBUTING][3] file with details on how to get started
with issue reporting or contributing to the upkeep of this project. In short,
use GitHub Issues, do not report anything to the Helm team.

The chart follows the technical guidelines / best practices [maintained][4] by the Helm team.

[1]: http://mail-archives.apache.org/mod_mbox/couchdb-user/
[2]: http://mail-archives.apache.org/mod_mbox/couchdb-dev/
[3]: https://github.com/apache/couchdb/blob/master/CONTRIBUTING.md
[4]: https://github.com/helm/charts/blob/master/REVIEW_GUIDELINES.md
[5]: https://github.com/kubernetes-sigs/kind
