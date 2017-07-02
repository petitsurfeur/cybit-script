#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo -e "${GREEN}### Installation de OpenVPN${NOCOLOR}"
apt install -y openvpn easy-rsa

echo ""
echo -e "${GREEN}### Creation du dossier /etc/openvpn/keys${NOCOLOR}" 
if [ ! -d /etc/openvpn/keys/ ]; then
  mkdir /etc/openvpn/keys
  cp /usr/share/easy-rsa /etc/openvpn -r
  cd /etc/openvpn/easy-rsa/ && ln -s openssl-1.0.0.cnf openssl.cnf
fi

echo ""
echo -e "${GREEN}### Configuration du fichier vars${NOCOLOR}"
vi /etc/openvpn/easy-rsa/vars

echo ""
echo -e "${GREEN}### Creation des cles pour le Serveur${;NOCOLOR}"
cd /etc/openvpn/easy-rsa
source vars
./clean-all
./build-ca
./build-key-server server
openssl dhparam 4096 > /etc/openvpn/easy-rsa/keys/dh4096.pem
openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key
cd /etc/openvpn/easy-rsa/keys
cp ca.crt ca.key server.crt server.key ta.key dh4096.pem /etc/openvpn/server

echo ""
echo -e "${GREEN}### Creation du user openvpn${NOCOLOR}"
adduser --system --shell /usr/sbin/nologin --no-create-home openvpn

echo ""
echo -e "${GREEN}### Configuration du server${NOCOLOR}"
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
vi /etc/openvpn/server.conf

echo ""
echo -e "${GREEN}### Demarrage du serveur Openvpn${NOCOLOR}"
systemctl start openvpn
systemctl start openvpn@server

systemctl status openvpn*.service

echo ""
echo -e "${GREEN}### Activation au demarrage du serveur Openvpn${NOCOLOR}"
systemctl enable openvpn
systemctl enable openvpn@server


echo ""
echo -e "${GREEN}### Creation des cles pour le Client${NOCOLOR}"
mkdir -p /etc/openvpn/client-configs/files
chmod 700 /etc/openvpn/client-configs/files

cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/client-configs/base.conf
vi /etc/openvpn/client-configs/base.conf
cp /opt/Git_Repos/cybit-script/openvpn/make_config.sh /etc/openvpn/client-configs
chmod 700 /etc/openvpn/client-configs/make_config.sh


