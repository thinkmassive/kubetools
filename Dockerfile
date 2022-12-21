FROM debian:stable-slim

LABEL maintainer "Miller <alex@thinkmassive.org>"

ARG ARGOCD_VERSION=2.5.4
ARG TEKTONCDCLI_VERSION=0.28.0
ARG KNATIVE_VERSION=1.8.1
ARG HELM_VERSION=3.10.3
ARG JSONNET_VERSION=0.19.1
ARG JSONTOYAML_VERSION=0.1.0
ARG JB_VERSION=0.5.1
ARG KUBECTL_VERSION=1.25.5
#ARG KUBECTL_v126=v1.26.0
#ARG KUBECTL_v125=v1.25.5
#ARG KUBECTL_v124=v1.24.9
#ARG KUBECTL_v123=v1.23.15
#ARG KUBECTL_v122=v1.22.17


RUN apt-get update && apt-get upgrade && apt-get install -y curl git unzip

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /bin/kubectl \
  && rm kubectl

# install helm
RUN mkdir /tmp/helm \
  && curl -SsL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o helm.tgz \
  && tar -C /tmp/helm -xf helm.tgz \
  && install -o root -g root -m 0755 /tmp/helm/linux-amd64/helm /bin/helm \
  && rm -rf helm.tz /tmp/helm

# install jsonnet
RUN mkdir /tmp/jsonnet \
  && curl -L "https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz" -o jsonnet.tgz \
  && tar -C /tmp/jsonnet -xf jsonnet.tgz \
  && ls -la /tmp/jsonnet \
  && install -o root -g root -m 0755 /tmp/jsonnet/jsonnet /bin/jsonnet \
  && rm -rf jsonnet.tgz /tmp/jsonnet

# install jsonnet-bundler
RUN curl -SsLO https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v${JB_VERSION}/jb-linux-amd64 \
  && install -o root -g root -m 0755 jb-linux-amd64 /bin/jb \
  && rm jb-linux-amd64

# install gojsontoyaml
RUN mkdir /tmp/gojsontoyaml \
  && curl -L "https://github.com/brancz/gojsontoyaml/releases/download/v${JSONTOYAML_VERSION}/gojsontoyaml_${JSONTOYAML_VERSION}_linux_amd64.tar.gz" -o gojsontoyaml.tgz \
  && tar -C /tmp/gojsontoyaml -xf gojsontoyaml.tgz \
  && ls -la /tmp/gojsontoyaml \
  && install -o root -g root -m 0755 /tmp/gojsontoyaml/gojsontoyaml /bin/gojsontoyaml \
  && rm -rf gojsontoyaml.tgz /tmp/gojsontoyaml

# install argocd
RUN curl -sSLO "https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64" \
  && install -m 555 argocd-linux-amd64 /bin/argocd \
  && rm argocd-linux-amd64

# install tektoncd-cli
RUN curl -sSL -o tektoncd-cli.deb "https://github.com/tektoncd/cli/releases/download/v${TEKTONCDCLI_VERSION}/tektoncd-cli-${TEKTONCDCLI_VERSION}_Linux-64bit.deb" \
  && dpkg -i tektoncd-cli.deb \
  && rm tektoncd-cli.deb

# install knative
RUN curl -sSL -o kn-linux-amd64 "https://github.com/knative/client/releases/download/knative-v${KNATIVE_VERSION}/kn-linux-amd64" \
  && install -m 555 kn-linux-amd64 /bin/kn \
  && ls -l /bin/kn \
  && rm kn-linux-amd64
