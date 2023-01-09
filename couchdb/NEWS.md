# NEWS

## 3.6.2

- Change the `erlangCookie` to be auto-generated in a stateful fashion (i.e. we auto-generate it once, then leave that
  value alone). ([#78](https://github.com/apache/couchdb-helm/issues/78))
- Use Ingress `className` instead of `kubernetes.io/ingress.class` annotation which has been deprecated since Kubernetes 1.18+ ([#69](https://github.com/apache/couchdb-helm/issues/69))
