# kubetools

## Pre-release Software

This repo is still under development. It may be force-pushed often, so
please don't use it yet. This notice will be removed upon release.

---

This image bundles the following utilties and libraries, useful for
maintaining Kubernetes clusters:

Binaries in `/bin/`
- [argocd](https://github.com/argoproj/argo-cd/releases) GitOps controller
- [helm](https://github.com/helm/helm/releases) Kubernetes package
  manager
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
  Kubernetes CLI
- [jsonnet](https://github.com/prometheus-operator/kube-prometheus.git)
  data templating language
- [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler)
  jsonnet package manager (`jb`)
- [gojsontoyaml](https://github.com/brancz/gojsontoyaml/) JSON to YAML
  converter

The base image will be extended for various cloud providers.

## Usage

You can source the `kubetools.sh` script into your shell to get
aliases for each of the included applications:

- `kubetools` (runs `/bin/sh` in the container)
- `gojsontoyaml`
- `helm`
- `kubectl`
- `jb` (jsonnet-bundler)
- `jsonnet`

```shell
KUBETOOLS_ALIASES='kubetools gojsontoyaml helm jsonnet jb kubectl'

source kubetools.sh
```
