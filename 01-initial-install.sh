#!/bin/bash
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

# Mise-à-jour du Système

apt -y install sudo                          #
sudo apt update -y
sudo apt upgrade -y

# Installation of zippers and unzippers

sudo apt -y install unrar-free unzip zip                             # Archiver for .rar files

# System utilities and various tools

sudo apt -y install hardinfo hwinfo htop sysv-rc-conf  locate         # Displays system information

# Core tools

sudo apt -y install curl sudo iperf                           # Command line tool for transferring data with URL syntax

# Création de l'utilisateur
adduser cybitnap
usermod -a -G adm,sudo,www-data cybitnap

echo ""
echo "################################################################"
echo "# Core software installed                                      #"
echo "################################################################"
