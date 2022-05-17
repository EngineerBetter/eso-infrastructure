#!/bin/bash
echo "$0"
set -xeuo pipefail
GVM_ETCPROFILE="gvm.sh"
GVM_GO="go1.17.10"

# base packages, go needed in whatever version for gvm
DEBIAN_FRONTEND=noninteractive sudo apt-get update -qq &&\
DEBIAN_FRONTEND=noninteractive sudo apt-get install curl git mercurial make binutils bison gcc build-essential golang-go -y -qq

if [[ ! -f $HOME/.gvm/scripts/gvm ]]; then
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
fi 
source $HOME/.gvm/scripts/gvm
gvm install $GVM_GO 

# build profile.d script to setup default go version with gvm
cat << EOF > /tmp/gvm.sh
#!/bin/bash
[[ -s $HOME/.gvm/scripts/gvm ]] && source $HOME/.gvm/scripts/gvm
gvm use go1.17.10 --default
EOF
sudo mv /tmp/gvm.sh /etc/profile.d/gvm.sh
sudo chmod +x /etc/profile.d/gvm.sh
