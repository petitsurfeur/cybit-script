#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Installation de Openssh-server${NOCOLOR}"
#apt update
read -p "Port a utiliser pour le serveur SSH (ex: 2022): " ssh_port
read -p "Utilisateur a autoriser pour les connexions SSH (ex: $login :) " ssh_user

apt install -y openssh-server

if [ ! -f /etc/ssh/sshd_config.SAVE ]; then
 cp /etc/ssh/sshd_config /etc/ssh/sshd_config.SAVE
fi

echo ""
echo -e "${GREEN}### Configuration du fichier /etc/ssh/sshd_config${NOCOLOR}"
sed -i -e 's/^#*Port.*/Port '"$ssh_port"'/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*LoginGraceTime.*/LoginGraceTime 30/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*PermitRootLogin.*/PermitRootLogin no/' '/etc/ssh/sshd_config'
sed -i '/PermitRootLogin no/a\AllowUsers '"$ssh_user"'' '/etc/ssh/sshd_config'
sed -i -e 's/^#*MaxStartups.*$/MaxStartups 3:50:10/g' /'etc/ssh/sshd_config'

echo ""
echo -e "${GREEN}--> Redemarrage du service${NOCOLOR}"
service ssh restart

echo ""
echo -e "${RED}### Penser a modifier le port SSH $ssh_port dans Putty${NOCOLOR}"
echo ""
