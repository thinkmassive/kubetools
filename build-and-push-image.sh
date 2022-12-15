#!/bin/bash

KUBETOOLS_IMAGE='thinkmassive/kubetools'
KUBETOOLS_TAG='v0.2.0'

docker build -t $KUBETOOLS_IMAGE:$KUBETOOLS_TAG --no-cache $KUBETOOLS_BUILD_ARGS .

docker push $KUBETOOLS_IMAGE:$KUBETOOLS_TAG
