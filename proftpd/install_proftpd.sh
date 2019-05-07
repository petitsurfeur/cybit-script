#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e " ${GREEN}### Installation de Proftpd avec TLS/SSL${NOCOLOR}"

apt install proftpd openssl --yes

if [ ! -f /etc/proftpd/proftpd.conf.SAVE ]; then
 cp /etc/ptoftpd/proftpd.conf /etc/proftpd/proftpd.conf.SAVE
fi


echo ""
echo -e " ${green}### Installation de Proftpd terminee${NOCOLOR}"
