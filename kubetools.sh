#!/bin/bash


##################
# Input variables
##################

KUBETOOLS_ALIASES="${KUBETOOLS_ALIASES:-kubetools argocd helm jb jsonnet kn kubectl tkn}"
KUBETOOLS_BASHRC="${KUBETOOLS_BASHRC:-$HOME/.bashrc}"
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
  echo "  --install adds/updates kubetools variables+aliases in .bashrc"
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
  if [ ! -e $KUBETOOLS_BASHRC ]; then
    echo "[ERR] File not found: $KUBETOOLS_BASHRC"
    exit 1
  else
    echo "Installing/updating kubetools variables and aliases in:"
    echo " $KUBETOOLS_BASHRC"
    echo
    for cmd in $KUBETOOLS_ALIASES; do
      #echo -en "  $cmd:\t"
      local alias_line="alias $cmd='$KUBETOOLS_SCRIPT $cmd'"
      if [ $(grep -c "^alias $cmd=" $KUBETOOLS_BASHRC) -gt 0 ]; then
        sed -i "s|^alias $cmd=.*|$alias_line|" $KUBETOOLS_BASHRC && \
          #echo "(updated)"
          printf '  %-20s %s\n' "alias $cmd: " 'updated' || \
          printf '  %-20s %s\n' "alias $cmd: " 'ERROR'
      else
        echo "$alias_line" >> $KUBETOOLS_BASHRC && \
	  #echo "(installed)"
          printf '  %-20s %s\n' "alias $cmd: " 'installed' || \
          printf '  %-20s %s\n' "alias $cmd: " 'ERROR'
      fi
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

kt_uninstall () {
  if [ ! -e $KUBETOOLS_BASHRC ]; then
    echo "[ERR] File not found: $KUBETOOLS_BASHRC"
    exit 1
  else
    echo "Uninstalling kubetools variables and aliases from:"
    echo " $KUBETOOLS_BASHRC"
    echo
    for cmd in $KUBETOOLS_ALIASES; do
      if [ $(grep -c "^alias $cmd=" $KUBETOOLS_BASHRC) -gt 0 ]; then
        sed -i "/^alias $cmd=.*/d" $KUBETOOLS_BASHRC && \
          printf '  %-20s %s\n' "alias $cmd: " 'removed' || \
          printf '  %-20s %s\n' "alias $cmd: " 'ERROR'
      else
        printf '  %-20s %s\n' "alias $cmd: " 'absent'
      fi
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
    '--help' | '-h') kt_help;;
    --*) echo "Unknown option '$1'"; echo; kt_help;;
    *)
      $KUBETOOLS_RUN $@
      #shift
      #echo $KUBETOOLS_RUN $@;;
  esac
fi

