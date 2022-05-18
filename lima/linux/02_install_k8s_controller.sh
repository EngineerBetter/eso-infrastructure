#!/bin/bash
echo "$0"
set -xeuo pipefail
ENVTEST_ETC="setup-envtest.sh"
ENVTEST_VERSION="1.20.2"

go install github.com/mikefarah/yq/v4@latest
go install github.com/onsi/ginkgo/v2/ginkgo@latest 
go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest

# show available versions
setup-envtest list --os $(go env GOOS) --arch $(go env GOARCH)

cat << EOF > /tmp/$ENVTEST_ETC
source <(setup-envtest use $ENVTEST_VERSION -p env --os $(go env GOOS) --arch $(go env GOARCH))
export ETCD_UNSUPPORTED_ARCH=arm64
EOF
sudo mv /tmp/$ENVTEST_ETC /etc/profile.d/$ENVTEST_ETC
sudo chmod +x /etc/profile.d/$ENVTEST_ETC
