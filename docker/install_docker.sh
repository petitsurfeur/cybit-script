#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e " ${GREEN}### Installation de Docker${NOCOLOR}"

apt-get remove docker docker-engine docker.io

apt-get install apt-transport-https ca-certificates curl software-propserties-common gnupg2

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee -a /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install docker-ce
systemctl enable docker

echo -e " ${GREEN}### Installation de Docker${NOCOLOR}"
curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo ""
read -p "Voulez-vous tester le container Hello-world [O/n] ? " docker_hello_choice
  if [[ "$docker_hello_choice" = 'O' ]]; then
  docker run hello-world
  fi
