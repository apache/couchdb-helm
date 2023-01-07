# NEWS

## 3.7.0

- Simplified the `adminHash` in the secret
- Added the `autoSetup` to automatically finalize the cluster after installation

## 3.6.2

- Change the `erlangCookie` to be auto-generated in a stateful fashion (i.e. we auto-generate it once, then leave that
  value alone). ([#78](https://github.com/apache/couchdb-helm/issues/78))
