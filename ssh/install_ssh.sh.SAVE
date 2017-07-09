#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Installation de Openssh-server${NOCOLOR}"
#apt update
apt install -y openssh-server

if [ ! -f /etc/ssh/sshd_config.SAVE ]; then
 cp /etc/ssh/sshd_config /etc/ssh/sshd_config.SAVE
fi

echo ""
echo -e "${GREEN}### Configuration du fichier /etc/ssh/sshd_config${NOCOLOR}"
sed -i -e 's/^#*Port.*/Port 2022/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*LoginGraceTime.*/LoginGraceTime 30/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*PermitRootLogin.*/PermitRootLogin no/' '/etc/ssh/sshd_config'
sed -i '/PermitRootLogin no/a\AllowUsers' '/etc/ssh/sshd_config'
sed -i -e 's/^#*MaxStartups.*$/MaxStartups 3:50:10/g' /'etc/ssh/sshd_config'

echo ""
echo -e "${GREEN}### Redemarrage du service${NOCOLOR}"
service ssh restart

echo ""
echo -e "${RED}### Penser a modifier AllowUsers${NOCOLOR}"
echo ""
