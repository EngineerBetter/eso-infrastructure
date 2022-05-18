#!/bin/bash
echo "$0"
set -xeuo pipefail

# check the folder is mounted read-write 
grep "/Users/$USER/workspace/external-secrets" /proc/mounts |grep ' rw,'

# check the folder contains expected repo
cd /Users/$USER/workspace/external-secrets
git remote -v |grep "origin.git@github.com:external-secrets/external-secrets.git"