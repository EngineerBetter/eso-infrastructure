#!/bin/bash
echo "$0"
set -xeuo pipefail
GVM_ETC="gvm.sh"
GVM_GO="go1.17.10"

# base packages, 
# golang is needed in whatever version for gvm to be able to install its managed versions
DEBIAN_FRONTEND=noninteractive sudo apt-get update -qq &&\
DEBIAN_FRONTEND=noninteractive sudo apt-get install curl git mercurial make binutils bison gcc build-essential golang-go -y -qq

# Using yq install via go in short term due to snap 503 http errors
#sudo snap install yq

if [[ ! -f $HOME/.gvm/scripts/gvm ]]; then
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
fi 
source $HOME/.gvm/scripts/gvm
gvm install $GVM_GO 

# build profile.d script to setup default go version with gvm
cat << EOF > /tmp/$GVM_ETC
#!/bin/bash
[[ -s $HOME/.gvm/scripts/gvm ]] && source $HOME/.gvm/scripts/gvm
gvm use $GVM_GO --default
EOF
sudo mv /tmp/$GVM_ETC /etc/profile.d/$GVM_ETC
sudo chmod +x /etc/profile.d/$GVM_ETC