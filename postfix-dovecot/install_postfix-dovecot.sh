#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo -e "${GREEN}### Mise-a-jour du systeme${NOCOLOR}"
#apt update && apt upgrade

echo -e "${GREEN}### Configuration du hostname${NOCOLOR}"

read -p "Nom du serveur (ex: mail) : " server_name
read -p "Nom de domaine utilise (ex: mail.domaine.net) : " server_domain_name

hostnamectl set-hostname --static $server_name
vi /etc/hosts

echo $(hostname -f) > /etc/mailname

echo ""
echo -e "${RED} !! Le serveur s'appelle ${NOCOLOR} " $(hostname) et "${RED} le FQDN est ${NOCOLOR} " $(hostname --fqdn)

echo -e "${GREEN}### Installation de Unbound DNS Resolver${NOCOLOR}"
apt install unbound dnsutils resolvconf

su -c "unbound-anchor -a /var/lib/unbound/root.key" - unbound
systemctl reload unbound

echo "nameserver 127.0.0.1" >> /etc/resolvconf/resolv.conf.d/head



