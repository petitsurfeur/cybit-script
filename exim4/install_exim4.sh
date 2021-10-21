#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

#read -p "Email de root du serveur : " root_email

#read -p "Email vers qui envoyer un mail de test : " test_email

if [ -z ${admin_email+x} ]; then
    read -p "Email du destinataire (admin@xxx.xx) : " admin_email
fi

if [ -z ${fqdn+x} ]; then
  read -p "DNS complet (ex: tatooine.dns.net) : " fqdn
fi


echo -e "${GREEN}### Installation d'Exim4 ###${NOCOLOR}"
apt install -y exim4


echo -e "${GREEN}### Configuration d'Exim4 ###${NOCOLOR}"
echo -e "repondre 1 / cyb.pw / N/A / N/A / N/A / admin@cybtech.net "
dpkg-reconfigure exim4-config


  if [ ! -f /etc/aliases.SAVE ]; then
    cp /etc/aliases /etc/aliases.SAVE
#   sed -i -e 's/^#*: root/: '"$root_email"'/' '/etc/aliases'
  fi

#  if [ ! -f /etc/exim4/update-exim4.conf.conf.SAVE ]; then
#    cp /etc/exim4/update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf.SAVE
#  fi

#echo -e "${GREEN}### Copie du fichier de conf${NOCOLOR}"
#cp update-exim4.conf.conf /etc/exim4/

echo ""
echo -e " ${GREEN}### Definition d'un mail a root${NOCOLOR}"
echo "Pensez a ajouter un mail a root dans /etc/mailname"


echo -e "${GREEN}### Redémarrage d'Exim4${NOCOLOR}"
systemctl restart exim4

echo -e "${GREEN}### Envoi d'un mail de test${NOCOLOR}"
echo -e "${RED}### ATTENDRE 10 sec${NOCOLOR}"
echo "Ceci est un mail de test." | mail -s Test_Envoi_Mail_$fqdn $admin_email
sleep 10
tail -20 /var/log/exim4/mainlog
