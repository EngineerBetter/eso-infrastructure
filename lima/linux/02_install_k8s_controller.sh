#!/bin/bash
echo "$0"
set -xeuo pipefail
ENVTEST_ETC="setup-envtest.sh"
ENVTEST_VERSION="1.20.2"

go install github.com/onsi/ginkgo/v2/ginkgo@latest 
go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest

# show available versions
setup-envtest list --os $(go env GOOS) --arch $(go env GOARCH)

cat << EOF > /tmp/setup-envtest.sh
source <(setup-envtest use $ENVTEST_VERSION -p env --os $(go env GOOS) --arch $(go env GOARCH))
export ETCD_UNSUPPORTED_ARCH=arm64
EOF
sudo mv /tmp/setup-envtest.sh /etc/profile.d/setup-envtest.sh
sudo chmod +x /etc/profile.d/setup-envtest.sh
