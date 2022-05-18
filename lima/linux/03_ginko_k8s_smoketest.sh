#!/bin/bash
echo "$0"
set -xeuo pipefail

cd /Users/$USER/workspace/external-secrets
go mod download -x

cd /Users/$USER/workspace/external-secrets/pkg/controllers/crds
ginkgo