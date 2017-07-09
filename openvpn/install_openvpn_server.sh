#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo -e "${GREEN}### Installation de OpenVPN${NOCOLOR}"
#apt install -y openvpn easy-rsa
read -p "Voulez-vous installer les packages [O/n] ? " openvpn_install
  if [[ "$openvpn_install" = 'O' ]]; then
    wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -
    echo "deb http://build.openvpn.net/debian/openvpn/release/2.4 stretch main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
    apt update && apt install openvpn easy-rsa

echo ""
echo -e "${GREEN}### Creation du dossier /etc/openvpn/keys${NOCOLOR}" 
    if [ ! -d /etc/openvpn/keys/ ]; then
      mkdir /etc/openvpn/keys
      cp /usr/share/easy-rsa /etc/openvpn -r
    cd /etc/openvpn/easy-rsa/ && ln -s openssl-1.0.0.cnf openssl.cnf
    fi

    echo ""
    echo -e "${GREEN}### Creation du user openvpn${NOCOLOR}"
    adduser --system --shell /usr/sbin/nologin --no-create-home openvpn
  fi
    
echo ""
echo -e "${GREEN}### Configuration du fichier vars${NOCOLOR}"
sleep 8
vi /etc/openvpn/easy-rsa/vars

echo ""
echo -e "${GREEN}### Creation des cles pour le Serveur${NOCOLOR}"
read -p "Voulez-vous creer les cles pour le serveur [O/n] ? " openvpn_serverKeys
  if [[ "$openvpn_serverKeys" = 'O' ]]; then
    cd /etc/openvpn/easy-rsa
    source vars
    ./clean-all
    sleep 5
    ./build-ca
    sleep 5
    ./build-key-server server
    sleep 5
    openssl dhparam 4096 > /etc/openvpn/easy-rsa/keys/dh4096.pem
    sleep 5
    openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key
    sleep 5
    cd /etc/openvpn/easy-rsa/keys
    cp ca.crt ca.key server.crt server.key ta.key dh4096.pem /etc/openvpn/server

    echo ""
    echo -e "${GREEN}### Configuration du server${NOCOLOR}"
    gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
    sleep 8
    vi /etc/openvpn/server.conf

    echo ""
    echo -e "${GREEN}### Demarrage du serveur Openvpn${NOCOLOR}"
    sleep 8
    systemctl start openvpn
    systemctl start openvpn@server
 
    systemctl status openvpn*.service
    
    echo ""
    echo -e "${GREEN}### Activation au demarrage du serveur Openvpn${NOCOLOR}"
    systemctl enable openvpn
    systemctl enable openvpn@server
  fi

echo ""
echo -e "${GREEN}### Creation des cles pour le Client${NOCOLOR}"
sleep 8
read -p "Voulez-vous creer les cles pour les Clients [O/n] ? " openvpn_clientKeys
  if [[ "openvpn_clientKeys" = 'O' ]]; then
    mkdir -p /etc/openvpn/client-configs/files
    chmod 700 /etc/openvpn/client-configs/files

    cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/client-configs/base.conf

    echo ""
    echo -e "${GREEN}### Parametrage du fichier de base pour les clients${NOCOLOR}"
    vi /etc/openvpn/client-configs/base.conf
    cp /opt/Git_Repos/cybit-script/openvpn/make_config.sh /etc/openvpn/client-configs
    chmod 700 /etc/openvpn/client-configs/make_config.sh

    echo ""
    echo -e "${RED}### Reste plus qu'a executer /etc/openvpn/client-configs/make_config.sh${NOCOLOR}"
    read -p "Nom du Client N.1 : " client1
    cd /etc/openvpn/easy-rsa
    ./build-key $client1
    cd /etc/openvpn/client-configs && ./make_config $client1
  fi

