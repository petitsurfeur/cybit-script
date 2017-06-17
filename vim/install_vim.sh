#!/bin/bash
set -e

# Install and configure vim
#apt update

echo ""
echo "### Desinstallation de vim-tiny et installation de Vim"
apt remove -y vim-tiny && apt install -y vim

echo ""
echo "### Copie du fichier de configuration"
cp vimrc.local /etc/vim/
