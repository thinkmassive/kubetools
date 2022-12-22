# kubetools

A toolbox for working with Kubernetes manifests and clusters, packaged as a
container image, with a helper script to easily run the utilities as if they
were installed natively on the host system.

This is primarily intended for use in development and lab environments. For
secure environments (build pipelines, production clusters), it is recommended
to use slimmed down images that contain only the essentials.

The following tools are included:

- [argocd](https://github.com/argoproj/argo-cd/releases) GitOps controller
- [tektoncd-cli](https://github.com/tektoncd/cli/releases) CI/CD
- [knative](https://github.com/knative/client/releases) serverless framework
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

Eventually the base image might be extended for various cloud providers, but
none are included at this time.

## Usage

The `kubetools.sh` script makes it easy to use any of the bundled tools nearly
the same as if they were installed natively.

Simply run `./kubetools.sh <cmd> [<arg(s)>]` to launch `<cmd>`. You can also
run the script with no arguments to drop into a bash shell inside the container.

Aliases can be used to map the original tool names to use the helper script,
and the script even includes an option to easily add/remove these from your
`.bashrc`:

```shell
./kubetools.sh --install
./kubetools.sh --uninstall
```

## Configuation

Default options can be overridden by the following environment variables:

| Env var                | Description                    | Default value |
|------------------------|--------------------------------|---------------|
| `KUBETOOLS_ALIASES`    | Aliases to create in `.bashrc` | `kubetools argocd helm jb jsonnet kn kubectl tkn` |
| `KUBETOOLS_BASHRC`     | Absolute path to `.bashrc` to modify | `$HOME/.bashrc` |
| `KUBETOOLS_KUBECONFIG` | Absolute path to KUBECONFIG    | `$HOME/.kube/config` |
| `KUBETOOLS_IMAGE`      | Container image repository     | `thinkmassive/kubetools` |
| `KUBETOOLS_TAG`        | Container image tag            | `v0.2.2` |
| `KUBETOOLS_VERBOSITY`  | Log level (0 to 2)             | `1` |

---
