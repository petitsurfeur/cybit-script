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

#sudo apt update -y
#sudo apt upgrade -y

# Installation of zippers and unzippers

sudo apt-get -y install rar                             # Archiver for .rar files
sudo apt-get -y install unrar-free                      # Unarchiver for .rar files
sudo apt-get -y install unzip                           # De-archiver for .zip files
sudo apt-get -y install zip                             # Archiver for .zip files

# System utilities and various tools

sudo apt-get -y install hardinfo                        # Displays system information
sudo apt-get -y install htop                            # Interactive processes viewer
sudo apt-get -y install hwinfo                          # Hardware identification system
sudo apt-get -y install sysv-rc-conf                    # SysV init runlevel configuration tool for the terminal
sudo apt-get -y install dns-utils                       # 
sudo apt-get -y install locate                          # 

# Core tools

sudo apt-get -y install curl                            # Command line tool for transferring data with URL syntax


echo ""
echo "################################################################"
echo "# Core software installed                                      #"
echo "################################################################"
