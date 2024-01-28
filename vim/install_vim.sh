#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

# Install and configure vim
#apt update

echo ""
echo -e "${GREEN}--> Desinstallation de vim-tiny et installation de Vim${NOCOLOR}"
apt remove -y vim-tiny && apt install vim -y 

echo ""
echo -e "${GREEN}--> Copie du fichier de configuration /etc/vim/vimrc.local${NOCOLOR}"
  if [ -f /etc/vim/vimrc.tiny ]; then
    rm /etc/vim/vimrc.tiny
  else echo -e "Fichier vimrc.tiny absent"
  fi

  cp /etc/vim/vimrc /etc/vim/vimrc.SAVE
  cp vimrc.local /etc/vim/



echo -e "${GREEN}--> Modification du fichier /usr/share/vim/vim81/defaults.vim${NOCOLOR}"
  if [ -f /usr/share/vim/vim81/defaults.vim ]; then
    cp /usr/share/vim/vim81/defaults.vim /usr/share/vim/vim81/defaults.vim.SAVE
    sed -i -e 's|set mouse=a|"set mouse=a|' '/usr/share/vim/vim81/defaults.vim'
    echo -e "Fichier defaults.vim mis a jour dans /usr/share/vim/vim81"
  else echo -e "Fichier defaults.vim dans /usr/share/vim/vim81 absent"
  fi

  if [ -f /usr/share/vim/vim82/defaults.vim ]; then
    cp /usr/share/vim/vim82/defaults.vim /usr/share/vim/vim82/defaults.vim.SAVE
    sed -i -e 's|set mouse=a|"set mouse=a|' '/usr/share/vim/vim82/defaults.vim'
    echo -e "Fichier defaults.vim mis a jour dans /usr/share/vim/vim82"
  else echo -e "Fichier defaults.vim /usr/share/vim/vim82 absent"
  fi

  if [ -f /usr/share/vim/vim90/defaults.vim ]; then
    cp /usr/share/vim/vim90/defaults.vim /usr/share/vim/vim90/defaults.vim.SAVE
    sed -i -e 's|set mouse=a|"set mouse=a|' '/usr/share/vim/vim90/defaults.vim'
    echo -e "Fichier defaults.vim mis a jour dans /usr/share/vim/vim90"
  else echo -e "Fichier defaults.vim /usr/share/vim/vim90 absent"
  fi

