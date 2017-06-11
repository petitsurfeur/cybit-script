#!/bin/bash
echo "Installation de Git"
apt install git --yes

echo "Configuration avec des couleurs"
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto

