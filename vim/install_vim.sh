#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

# Install and configure vim
#apt update

echo ""
echo -e "${GREEN}### Desinstallation de vim-tiny et installation de Vim${NOCOLOR}"
apt remove -y vim-tiny && apt install -y vim

echo ""
echo -e "${GREEN}### Copie du fichier de configuration${NOCOLOR}"
rm /etc/vim/vimrc.tiny
cp vimrc.local /etc/vim/
