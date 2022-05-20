#!/bin/bash
OPT="$1"
set -euo pipefail
#for Docker-Desktop local image registry accessible
#to Docker-Desktop's local Kubernetes

GITBRANCH="beach-team"
REPO="external-secrets"
TAG="$GITBRANCH"

IMAGE_REPO="image.repository=$REPO,image.tag=$TAG"
WEBHOOK_REPO="webhook.image.repository=$REPO,webhook.image.tag=$TAG"
CONTROLLER_REPO="certController.image.repository=$REPO,certController.image.tag=$TAG"

echo "Ensure build and deploy is bound to $GITBRANCH branch"
( cd ~/workspace/external-secrets
git checkout $GITBRANCH )



function deploy {
( cd ~/workspace/external-secrets

echo "Uninstalling external-secrets deployment if needed"
helm uninstall -n external-secrets external-secrets &> /dev/null ||true

helm upgrade --install --set ${IMAGE_REPO},${WEBHOOK_REPO},${CONTROLLER_REPO} \
 -n external-secrets --create-namespace \
 external-secrets deploy/charts/external-secrets 
)
}

function build-amd {
 ( 
  cd ~/workspace/external-secrets
  make build-amd64
  TARGETOS=linux TARGETARCH=amd64 docker build -t $REPO:$TAG . 
 )

}

function build-arm {
 (
  cd ~/workspace/external-secrets
  make build-arm64
  TARGETOS=linux TARGETARCH=arm64 docker build -t $REPO:$TAG . 
  )
}

function helmgen {
( cd ~/workspace/external-secrets
 make helm.generate )
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
  "helmgen")  
    helmgen
    ;;    
  *)
    echo "Usage: helmgen | build-amd | build-arm | deploy"
    exit 1
    ;;
esac
