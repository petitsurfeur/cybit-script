#!/bin/bash
set -e
#
# #################################################################
#
# Written to be used on 64 bits computers
# Author            : Erik Dubois
# Website           : http://www.erikdubois.be
#
# Modified by       : TheGreatYellow67 (TgY67)
# Version           : v1
# Start date        : 09/02/2017
# Last modified date: 06/05/2017
#
# #################################################################

###################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###################################################################

# Mise-à-jour du Système
#su -
#apt -y install sudo                          #
#usermod -a -G adm,sudo,www-data cybitnap
#exit

sudo apt update -y
sudo apt upgrade -y

# Installation of zippers and unzippers

sudo apt-get -y install rar unrar-free unzip zip                             # Archiver for .rar files

# System utilities and various tools

sudo apt-get -y install hardinfo hwinfo htop sysv-rc-conf dns-utils locate         # Displays system information

# Core tools

sudo apt-get -y install curl                            # Command line tool for transferring data with URL syntax


echo ""
echo "################################################################"
echo "# Core software installed                                      #"
echo "################################################################"
