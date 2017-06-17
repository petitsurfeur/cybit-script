#!/bin/bash
set -e

echo ""
echo "### Installation de Git"
apt install -y git

echo ""
echo "### Configuration avec des couleurs"
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto

echo ""
echo "### Lancer les commandes suivantes :"
echo " git config --global user.name [votre_pseudo]"
echo " git config --global user.email [em@il.com]"
