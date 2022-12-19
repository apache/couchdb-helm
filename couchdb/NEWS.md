# NEWS

## 3.6.5

- Simplified the `adminHash` in the secret
- Added the `autoSetup` to automatically finalize the cluster after installation

# 3.6.4

- Add `service.labels` value to pass along labels to the client-facing service
- Update `ingress` to use the service created by `service.enabled=true`,
  instead of the headless service
  ([#94](https://github.com/apache/couchdb-helm/issues/94))
  - This allows setting `service.annotations`, `service.labels`, etc. in a way that will be picked up by the ingress

# 3.6.3

- Add PersistentVolume annotations

## 3.6.2

- Change the `erlangCookie` to be auto-generated in a stateful fashion (i.e. we auto-generate it once, then leave that
  value alone). ([#78](https://github.com/apache/couchdb-helm/issues/78))
