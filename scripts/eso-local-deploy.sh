#!/bin/bash
OPT="$1"
set -euo pipefail
#for Docker-Desktop local image registry accessible
#to Docker-Desktop's local Kubernetes
REPO="external-secrets"
TAG="beach-team"

IMAGE_REPO="image.repository=$REPO,image.tag=$TAG"
WEBHOOK_REPO="webhook.image.repository=$REPO,webhook.image.tag=$TAG"
CONTROLLER_REPO="certController.image.repository=$REPO,certController.image.tag=$TAG"

function deploy {
( cd ~/workspace/external-secrets

helm uninstall -n external-secrets external-secrets &> /dev/null ||true

helm upgrade --install --set ${IMAGE_REPO},${WEBHOOK_REPO},${CONTROLLER_REPO} \
 -n external-secrets --create-namespace \
 external-secrets deploy/charts/external-secrets 
)
}

function build-amd {
( cd ~/workspace/external-secrets
TARGETOS=linux TARGETARCH=amd64 docker build -t $REPO:$TAG . )

}

function build-arm {
( cd ~/workspace/external-secrets
TARGETOS=linux TARGETARCH=arm64 docker build -t $REPO:$TAG . )
}

case $OPT in

  "deploy")
    deploy
    ;;
  "build-amd")
    build-amd
    ;;
  "build-arm")
    build-arm
    ;;
  *)
    echo "Usage: deploy | build-amd | build-arm "
    exit 1
    ;;
esac
