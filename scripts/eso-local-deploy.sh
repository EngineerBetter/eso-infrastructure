#!/bin/bash
OPT="$1"
set -euo pipefail
#for Docker-Desktop local image registry accessible
#to Docker-Desktop's local Kubernetes

GITBRANCH="beach-team"
REPO="external-secrets"
TAG="$GITBRANCH"

# Asking the user to enter the absolute path for the external-secrets directory
echo "Kindly enter the absolute path of the external-secrets directory"   
read ESO_PATH
BBLUE='\033[1;34m' #BoldBlue
NC='\033[0m' # No Color
echo -e "Your local absolute path for external-secrets, ESO_PATH is: $BBLUE$ESO_PATH$NC"

IMAGE_REPO="image.repository=$REPO,image.tag=$TAG"
WEBHOOK_REPO="webhook.image.repository=$REPO,webhook.image.tag=$TAG"
CONTROLLER_REPO="certController.image.repository=$REPO,certController.image.tag=$TAG"

echo -e "Ensure build and deploy is bound to $BBLUE$GITBRANCH$NC branch"
(
  cd "$ESO_PATH"
  git checkout $GITBRANCH
)

function deploy {
  (
    cd "$ESO_PATH"

    echo "Uninstalling external-secrets deployment if needed"
    helm uninstall -n external-secrets external-secrets &>/dev/null || true

    helm upgrade --install --set ${IMAGE_REPO},${WEBHOOK_REPO},${CONTROLLER_REPO} \
      -n external-secrets --create-namespace \
      external-secrets deploy/charts/external-secrets
  )
}

function build-amd {
  (
    cd "$ESO_PATH"
    make build-amd64
    TARGETOS=linux TARGETARCH=amd64 docker build -t $REPO:$TAG .
  )

}

function build-arm {
  (
    cd "$ESO_PATH"
    make build-arm64
    TARGETOS=linux TARGETARCH=arm64 docker build -t $REPO:$TAG .
  )
}

function helmgen {
  (
    cd "$ESO_PATH"
    make helm.generate
  )
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
