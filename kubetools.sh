#!/bin/bash


##################
# Input variables
##################

KUBETOOLS_ALIASES="${KUBETOOLS_ALIASES:-kubetools argocd helm jb jsonnet kn kubectl tkn}"
KUBETOOLS_ALIAS_FILE="${KUBETOOLS_ALIAS_FILE:-$HOME/.bash_aliases}"
KUBETOOLS_KUBECONFIG="${KUBETOOLS_KUBECONFIG:-$HOME/.kube/config}"
KUBETOOLS_IMAGE="${KUBETOOLS_IMAGE:-ghcr.io/thinkmassive/kubetools}"
KUBETOOLS_TAG="${KUBETOOLS_TAG:-main}"
KUBETOOLS_VERBOSITY="${KUBETOOLS_VERBOSITY:-1}"


######################
# Composite variables
######################

# Absolute path to this script
KUBETOOLS_SCRIPT="$(realpath ${BASH_SOURCE[0]})"

# Volumes to mount inside container
KUBETOOLS_VOLUMES="-v $(pwd):$(pwd)"
KUBETOOLS_VOLUMES+=" -v $KUBETOOLS_KUBECONFIG:$KUBETOOLS_KUBECONFIG"

# Command to run container w/user+group mapping
KUBETOOLS_RUN="docker run"
KUBETOOLS_RUN+=" -it --rm --name kubetools"
KUBETOOLS_RUN+=" --user $(id -u ${USER}):$(id -g ${USER})"
KUBETOOLS_RUN+=" --workdir $(pwd) $KUBETOOLS_VOLUMES"
KUBETOOLS_RUN+=" -e KUBECONFIG=$KUBETOOLS_KUBECONFIG"
KUBETOOLS_RUN+=" $KUBETOOLS_IMAGE:$KUBETOOLS_TAG"


############
# Functions
############

kt_help() {
  echo "KubeTools container image"
  echo
  echo "Usage: kubetools [--help|--install|--uninstall] [<cmd> [<arg(s)>]]"
  echo "  kubetools [--help|--install|--uninstall]"
  echo "  --install adds/updates kubetools aliases in .bash_aliases"
  echo "  --uninstall removes kubetools aliases from .bash_aliases"
  echo "  --versions prints current version of each bundled utility"
  echo "  --help prints these usage instructions"
  echo
  echo "  kubetools <cmd> [<arg(s)>]"
  for cmd in $KUBETOOLS_ALIASES; do echo "  $cmd"; done
}

kt_cmd() {
  echo "kubetools: running '$1'"
  echo $KUBETOOLS_RUN $@
}

kt_install () {
  if [ ! -e $KUBETOOLS_ALIAS_FILE ]; then
    echo "[ERR] File not found: $KUBETOOLS_ALIAS_FILE"
    exit 1
  else
    echo "Installing/updating kubetools variables and aliases in:"
    echo " $KUBETOOLS_ALIAS_FILE"
    echo
    for cmd in $KUBETOOLS_ALIASES; do
      local status=ERROR
      local alias_line="alias $cmd='$KUBETOOLS_SCRIPT $cmd'"
      if [ $(grep -c "^alias $cmd=" $KUBETOOLS_ALIAS_FILE) -gt 0 ]; then
        sed -i "s|^alias $cmd=.*|$alias_line|" $KUBETOOLS_ALIAS_FILE && status=updated
      else
        echo "$alias_line" >> $KUBETOOLS_ALIAS_FILE && status=installed
      fi
      printf '  %-20s %s\n' "alias $cmd: " "$status"
    #  [[ $KUBETOOLS_VERBOSITY -gt 1 ]] && echo -e "\n$cmd:\t$alias_cmd"
    #  alias $cmd="$alias_cmd"
    #  if [[ $KUBETOOLS_VERBOSITY -gt 1 ]]; then
    #    $alias_cmd --version >/dev/null && $alias_cmd --version
    #    $alias_cmd version >/dev/null && $alias_cmd version
    #    echo
    #  fi
    done
  fi
}

kt_uninstall() {
  if [ ! -e $KUBETOOLS_ALIAS_FILE ]; then
    echo "[ERR] File not found: $KUBETOOLS_ALIAS_FILE"
    exit 1
  else
    echo "Uninstalling kubetools variables and aliases from:"
    echo " $KUBETOOLS_ALIAS_FILE"
    echo
    for cmd in $KUBETOOLS_ALIASES; do
      local status=ERROR
      if [ $(grep -c "^alias $cmd=" $KUBETOOLS_ALIAS_FILE) -gt 0 ]; then
        sed -i "/^alias $cmd=.*/d" $KUBETOOLS_ALIAS_FILE && status=removed
      else
        status=absent
      fi
      printf '  %-20s %s\n' "alias $cmd: " "$status"
    done
  fi
}

kt_versions() {
  for cmd in $KUBETOOLS_ALIASES; do
    if [ $cmd != 'kubetools' ]; then
      echo
      echo "$cmd:"
      local alias_cmd="$KUBETOOLS_RUN $cmd"
      if $alias_cmd --version >/dev/null; then
        $alias_cmd --version
      else
        $alias_cmd version
      fi
    fi
  done
}

#############
# Entrypoint
#############

if [ $# -lt 1 ]; then
  [[ $KUBETOOLS_VERBOSITY -gt 1 ]] && echo "kubetools: $KUBETOOLS_RUN"
  $KUBETOOLS_RUN
else
  case $1 in
    '--install') kt_install;;
    '--uninstall') kt_uninstall;;
    '--versions') kt_versions;;
    '--help' | '-h') kt_help;;
    --*) echo "Unknown option '$1'"; echo; kt_help;;
    *)
      $KUBETOOLS_RUN $@
  esac
fi

