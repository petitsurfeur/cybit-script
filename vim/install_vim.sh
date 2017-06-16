#!/bin/bash
set -e

# Install and configure vim
#apt update
apt remove -y vim-tiny && apt install -y vim
cp vimrc.local /etc/vim/
