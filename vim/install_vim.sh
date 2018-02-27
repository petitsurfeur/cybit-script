#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

# Install and configure vim
#apt update

echo ""
echo -e "${GREEN}--> Desinstallation de vim-tiny et installation de Vim${NOCOLOR}"
apt remove -y vim-tiny 
apt install -y vim

echo ""
echo -e "${GREEN}--> Copie du fichier de configuration /etc/vim/vimrc.local${NOCOLOR}"
  if [ -f /etc/vim/vimrc.tiny ]; then
    rm /etc/vim/vimrc.tiny
  else echo -e "Fichier vimrc.tiny absent"
  fi
    cp vimrc.local /etc/vim/

echo ""
echo -e "${GREEN}--> Modification du fichier /usr/share/vim/vim80/defaults.vim${NOCOLOR}"
mv /usr/share/vim/vim80/defaults.vim /usr/share/vim/vim80/defaults.vim.SAVE && cp defaults.vim /usr/share/vim/vim80/
