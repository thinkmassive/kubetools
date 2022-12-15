#!/bin/bash

KUBETOOLS_ALIASES="${KUBETOOLS_ALIASES:-kubetools helm kubectl jsonnet jb argocd tektoncd-cli kn}"
KUBETOOLS_DIR_KUBE="${KUBETOOLS_DIR_KUBE:-$HOME/.kube}"
KUBETOOLS_IMAGE=${KUBETOOLS_IMAGE:-thinkmassive/kubetools}
KUBETOOLS_LOGLEVEL=${KUBETOOLS_LOGLEVEL:-1}
KUBETOOLS_TAG=${KUBETOOLS_TAG:-latest}

# Define list of volumes to map
KUBETOOLS_VOLUMES="-v \"$(pwd)\":\"$(pwd)\""
KUBETOOLS_VOLUMES+=" -v \"$KUBETOOLS_DIR_KUBE\":/root/.kube"

KUBETOOLS_RUN="DOCKER_UID=$(id -u) DOCKER_GID=$(id -g) docker run"
KUBETOOLS_RUN+=" -it --rm --name kubetools"
KUBETOOLS_RUN+=" --user $(id -u ${USER}):$(id -g ${USER})"
KUBETOOLS_RUN+=" --workdir $(pwd) $KUBETOOLS_VOLUMES"
KUBETOOLS_RUN+=" $KUBETOOLS_IMAGE:$KUBETOOLS_TAG"

HELM_CMD="$KUBETOOLS_RUN helm"
KUBECTL_CMD="$KUBETOOLS_RUN kubectl"
JSONNET_CMD="$KUBETOOLS_RUN jsonnet"
JSONNETBUNDLER_CMD="$KUBETOOLS_RUN jb"
ARGOCD_CMD="$KUBETOOLS_RUN argocd"
TEKTONCLI_CMD="$KUBETOOLS_RUN tektoncd-cli"
KNATIVE_CMD="$KUBETOOLS_RUN kn"

for cmd in $KUBETOOLS_ALIASES; do
  [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && echo -en "\n$cmd:\t"
  case $cmd in
    kubetools)
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && echo "$KUBETOOLS_RUN /bin/sh"
      alias kubetools="$KUBETOOLS_RUN /bin/sh";;
    argocd)
      alias argocd="$ARGOCD_CMD"
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && argocd version;;
    tektoncd-cli)
      alias tektoncd-cli="$TEKTONCLI_CMD"
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && tektoncd-cli version;;
    knative)
      alias kn="$KNATIVE_CMD"
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && kn version;;
    helm)
      alias helm="$HELM_CMD"
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && helm version;;
    kubectl)
      alias kubectl="$KUBECTL_CMD"
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && kubectl version;;
    jsonnet)
      alias jsonnet="$JSONNET_CMD"
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && jsonnet --version;;
    jb)
      alias jb="$JSONNETBUNDLER_CMD"
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && jb --version;;
    *)
      [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && echo "(not found)";;
  esac
done

