FROM debian:stable-slim

LABEL maintainer "thinkmassive <miller@lightning.engineering>"

ARG HELM_VERSION=3.10.3
ARG JSONNET_VERSION=0.19.1
ARG JSONTOYAML_VERSION=0.1.0
ARG JB_VERSION=0.5.1
ARG KUBE_PROM_VERSION=0.9
ARG KUBE_PROM_COMMIT=452aaed72e36acb31cae93cfa85a5d9c3d3d2ec7
ARG KUBECTL_VERSION=v1.21.14

ENV JSONNET_PATH=/kube-prometheus/vendor

RUN apt-get update && apt-get install -y curl git unzip

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
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

# install kube-prometheus library
RUN mkdir /kube-prometheus \
  && cd /kube-prometheus \
  && curl -LO "https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/release-${KUBE_PROM_VERSION}/build.sh" \
  && chmod +x build.sh \
  && jb init \
  && jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@release-$KUBE_PROM_VERSION \
  && chmod -Rv 777 /kube-prometheus
