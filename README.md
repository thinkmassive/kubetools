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

The official images are hosted at Github and signed by Cosign:
- https://github.com/thinkmassive/kubetools/pkgs/container/kubetools

```shell
docker pull ghcr.io/thinkmassive/kubetools:main
```

Additional images _may_ be published to
[DockerHub](https://hub.docker.com/repository/docker/thinkmassive/kubetools)
for convenience, although using the GHCR images is preferred.

The `kubetools.sh` script makes it easy to use any of the bundled tools nearly
the same as if they were installed natively:

```shell
./kubetools.sh [<cmd> [<arg(s)>]]
```

### Examples
- List nodes using `kubectl`: `./kubetools.sh kubectl get nodes`
- List installed `helm` releases: `./kubetools.sh helm ls`
- Get a shell inside the container: `./kubetools.sh`

### Aliases
Aliases can be used to map the original tool names to call the helper script.
The script includes an option to easily add/remove them from `.bashrc`:

- Add/update aliases: `./kubetools.sh --install`
- Remove aliases: `./kubetools.sh --uninstall`

## Configuation

Default options can be overridden by the following environment variables:

| Env var                | Description                    | Default value |
|------------------------|--------------------------------|---------------|
| `KUBETOOLS_ALIASES`    | Aliases to create in `.bashrc` | `kubetools argocd helm jb jsonnet kn kubectl tkn` |
| `KUBETOOLS_BASHRC`     | Absolute path to `.bashrc` to modify | `$HOME/.bashrc` |
| `KUBETOOLS_KUBECONFIG` | Absolute path to KUBECONFIG    | `$HOME/.kube/config` |
| `KUBETOOLS_IMAGE`      | Container image registry & repository | `ghcr.io/thinkmassive/kubetools` |
| `KUBETOOLS_TAG`        | Container image tag            | `main` |
| `KUBETOOLS_VERBOSITY`  | Log level (0 to 2)             | `1` |

---
