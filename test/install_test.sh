#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e
#
# #################################################################
#
# Written to be used on 64 bits computers
# Author            : Petitsurfeur
# Website           : http://
#
# Modified by       : 
# Version           : v1
# Start date        : 16/06/2017
# Last modified date: 16/06/2017
#
# #################################################################

###################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###################################################################

echo ""


read -p "Port a utiliser pour le serveur SSH : " ssh_port
read -p "Utilisateur a autoriser pour les connexions SSH : " ssh_user


echo -e "${GREEN}### Configuration du fichier /etc/ssh/sshd_config${NOCOLOR}"
sed -i -e 's/^#*Port.*/Port '"$ssh_port"'/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*LoginGraceTime.*/LoginGraceTime 30/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*PermitRootLogin.*/PermitRootLogin no/' '/etc/ssh/sshd_config'
sed -i '/PermitRootLogin no/a\AllowUsers '"$ssh_user"'' '/etc/ssh/sshd_config'
sed -i -e 's/^#*MaxStartups.*$/MaxStartups 3:50:10/g' /'etc/ssh/sshd_config'

