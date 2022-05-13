#!/bin/bash
set -euo pipefail

TARGET=$(fly targets |grep "ci\.engineerbetter\.com" |awk '{print $1}')
TEAM="kubernetes-eso"
#TODO: have this read from pipeline config
JOBS="set-pipeline lint unit-tests build deploy validation-tests"

#TODO: detect from ../workspace/external-secrets branch
PIPELINE="eso-cd"

Echo "Executing fly trigger job for target $TARGET and pipeline $PIPELINE"
fly -t $TARGET check-resource --team=$TEAM -r $PIPELINE/external-secrets-trunk

for JOB in $JOBS; do
  fly -t $TARGET trigger-job --team=$TEAM -j $PIPELINE/$JOB -w
done
