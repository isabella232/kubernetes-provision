#!/bin/bash

TILLER_DIST_FILE=$1
TILLER_DEPLOYMENT_FILE='./deploy/tiller/base/deployment.yaml'

helm init --output yaml \
  --service-account tiller \
  --history-max 10 \
  --replicas 1 \
  --override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}' \
  --tiller-namespace '' \
  > "$TILLER_DEPLOYMENT_FILE" &&

kustomize build ./deploy/tiller > "$TILLER_DIST_FILE" &&

read -r -d '' NOTE << EOM
# This file was generated by ./hack/generate-tiller-deployment.sh;
# do not modify manually.
EOM

echo -e "$NOTE\n$(cat $TILLER_DEPLOYMENT_FILE)" > "$TILLER_DEPLOYMENT_FILE" &&
echo -e "$NOTE\n$(cat $TILLER_DIST_FILE)" > "$TILLER_DIST_FILE"
