#!/bin/bash

KUBETOOLS_ALIASES="${KUBETOOLS_ALIASES:-helm kubectl jsonnet jb argocd tkn kn}"
KUBETOOLS_DIR_KUBE="${KUBETOOLS_DIR_KUBE:-$HOME/.kube}"
KUBETOOLS_IMAGE=${KUBETOOLS_IMAGE:-thinkmassive/kubetools}
KUBETOOLS_LOGLEVEL=${KUBETOOLS_LOGLEVEL:-2}
KUBETOOLS_TAG=${KUBETOOLS_TAG:-v0.2.2}

# Define list of volumes to map
KUBETOOLS_VOLUMES="-v $(pwd):$(pwd)"
KUBETOOLS_VOLUMES+=" -v $KUBETOOLS_DIR_KUBE:/root/.kube"

#KUBETOOLS_RUN="DOCKER_UID=$(id -u) DOCKER_GID=$(id -g) docker run"
KUBETOOLS_RUN="docker run"
KUBETOOLS_RUN+=" -it --rm --name kubetools"
KUBETOOLS_RUN+=" --user $(id -u ${USER}):$(id -g ${USER})"
KUBETOOLS_RUN+=" --workdir $(pwd) $KUBETOOLS_VOLUMES"
KUBETOOLS_RUN+=" $KUBETOOLS_IMAGE:$KUBETOOLS_TAG"
export KUBETOOLS_RUN

[[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && echo "kubetools: $KUBETOOLS_RUN"
alias kubetools="$KUBETOOLS_RUN"

for cmd in $KUBETOOLS_ALIASES; do
  alias_cmd="$KUBETOOLS_RUN $cmd"
  [[ $KUBETOOLS_LOGLEVEL -gt 1 ]] && echo -e "\n$cmd:\t$alias_cmd"
  alias $cmd="$alias_cmd"
  if [[ $KUBETOOLS_LOGLEVEL -gt 1 ]]; then
    $alias_cmd --version >/dev/null && $alias_cmd --version
    $alias_cmd version >/dev/null && $alias_cmd version
    echo
  fi
done

