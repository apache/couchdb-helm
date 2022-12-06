# Deprecated

Per [this issue](https://github.com/apache/couchdb-helm/issues/62), we plan to move things in `./docs` here
to GitHub releases and follow the helm community's guidance on 
release practices for helm charts.

# Migration Path

In order to migrate the old .tgz files, we:

- Will find the latest commit that modified a .tgz
- Sanity check that `Chart.yaml` represents the same version
- Forego any further file consistency checks (this is best effort)
- Presume that the git state matches what is in the .tgz at that time
- Tag and release the given commit to GitHub Releases using [`chart-releaser`](https://github.com/helm/chart-releaser)

## How To

1. `cd docs` to move into this directory
2. Install the `chart-releaser` binary (only one architecture defined)
```bash
cd docs
./install-cr.sh
```
3. Build an inventory of what .tgz files exist in the directory
```bash
./get-inventory.sh
```
4. Sanity check that things look appropriate
```bash
./check-inventory.sh
```
5. Run the release dry-run
```bash
# ./release-inventory.sh {{ owner }}
# i.e.
./release-inventory.sh colearendt
```
6. Check that things look good, then run the actual release process
```bash
# ./release-inventory.sh {{ owner }} execute
# (see docs for more info / other args)
# i.e.
./release-inventory.sh colearendt execute
```

NOTE: we have not done anything to sign chart packages here, though `chart-releaser` supports doing so.
