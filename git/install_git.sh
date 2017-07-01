#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Installation de Git${NOCOLOR}"
apt install -y git

echo ""
echo -e "${GREEN}### Configuration avec des couleurs${NOCOLOR}"
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto

echo ""
echo -e "${RED}### Lancer les commandes suivantes :"
echo " git config --global user.name [votre_pseudo]"
echo -e " git config --global user.email [em@il.com]${NOCOLOR}"
