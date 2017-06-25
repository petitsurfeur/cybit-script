#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo -e "${GREEN}### Installation de OpenVPN${NOCOLOR}"
apt install -y openvpn easy-rsa

echo ""
echo -e "${GREEN}### Creation du dossier /etc/openvpn/keys${NOCOLOR}" 
mkdir /etc/openvpn/keys
cp /usr/share/easy-rsa /etc/openvpn -r

echo ""
echo -e "${GREEN}### Configuration du fichier vars${NOCOLOR}"
vi /etc/openvpn/easy-rsa/vars

echo ""
echo -e "${GREEN}### Creation des cles${NOCOLOR}"
cd /etc/openvpn/easy-rsa
source vars
./clean-all
./build-ca
./build-key-server server

