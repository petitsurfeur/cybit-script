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
echo -e "${GREEN}### Mise-à-jour du Système${NOCOLOR}"

apt -y install sudo                          #
sudo apt update -y
sudo apt upgrade -y

echo ""
echo -e "${GREEN}### Installation of zippers and unzippers${NOCOLOR}"

sudo apt -y install unrar-free unzip zip                             # Archiver for .rar files

echo ""
echo -e "${GREEN}### System utilities and various tools${NOCOLOR}"

sudo apt -y install hardinfo hwinfo htop sysv-rc-conf  locate         # Displays system information

# Core tools

sudo apt -y install curl sudo iperf                           # Command line tool for transferring data with URL syntax

echo ""
echo -e "${GREEN}### Création de l'utilisateur${NOCOLOR}"
if [ ! -f /home/cybitnap/ ]; then
 adduser cybitnap
fi

usermod -a -G adm,sudo,www-data cybitnap

echo ""
echo "${GREEN}################################################################"
echo "# Core software installed                                      #"
echo "################################################################${NOCOLOR}"
