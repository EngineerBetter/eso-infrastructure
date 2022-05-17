#!/bin/bash
echo "$0"
set -xeuo pipefail

# failed check will rase non 0 exit code to macos shell as well
grep "/Users/$USER/workspace/external-secrets" /proc/mounts |grep ' rw,'

# check the folder is expected repo
cd /Users/$USER/workspace/external-secrets
git remote -v |grep "origin.git@github.com:external-secrets/external-secrets.git"