#!/bin/bash
set -euo pipefail
if [[ $(uname) != "Darwin" ]]; then echo "this script is for Darwin macos, your system is $(uname)"; exit 1; fi
if [[ ! $(which lima) ]]; then echo "please install lima 'brew install lima'"; fi 
pp='\033[0;35m' #purple
nc='\033[0m'    #nocolor
#-----------------------
LIMA_VM_NAME="default"
LIMA_TMP="/tmp/lima"

# startup check lima instance
if test -e ~/.lima/${LIMA_VM_NAME}
 then 
  printf "${pp}\nStarting lima instance: $LIMA_VM_NAME\n"
  limactl start ${LIMA_VM_NAME} 
else
  printf "${pp}\nCreating and starting lima instance: $LIMA_VM_NAME${nc}\n"
  limactl start --name=${LIMA_VM_NAME} ./lima-vm.yaml --tty=false ||true
fi

printf "${pp}\nCopying linux scripts to VM in $LIMA_TMP${nc}\n"
limactl shell ${LIMA_VM_NAME} mkdir -p $LIMA_TMP
limactl copy ./linux/* ${LIMA_VM_NAME}:$LIMA_TMP 

printf "${pp}\nChecking for external-secrets repository mount ${nc}\n"
limactl shell ${LIMA_VM_NAME} $LIMA_TMP/00_mount_check.sh

printf "${pp}\nInstalling prerequisite packages${nc}\n"
limactl shell ${LIMA_VM_NAME} $LIMA_TMP/01_install_prereq.sh

printf "${pp}\nInstalling and setting up k8s test controller${nc}\n"
limactl shell ${LIMA_VM_NAME} $LIMA_TMP/02_install_k8s_controller.sh

printf "${pp}\nSmoketesting ginko and k8s controller${nc}\n"
limactl shell ${LIMA_VM_NAME} $LIMA_TMP/03_ginko_k8s_smoketest.sh
