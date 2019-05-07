#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

#read -p "Email de root du serveur : " root_email

#read -p "Email vers qui envoyer un mail de test : " test_email

echo -e "${GREEN}### Installation d'Exim4 ###${NOCOLOR}"
apt install -y exim4

  if [ ! -f /etc/aliases.SAVE ]; then
    cp /etc/aliases /etc/aliases.SAVE
#   sed -i -e 's/^#*: root/: '"$root_email"'/' '/etc/aliases'
  fi

  if [ ! -f /etc/exim4/update-exim4.conf.conf.SAVE ]; then
    cp /etc/exim4/update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf.SAVE
  fi

echo -e "${GREEN}### Copie du fichier de conf${NOCOLOR}"
cp update-exim4.conf.conf /etc/exim4/

echo -e "${GREEN}### Redémarrage d'Exim4${NOCOLOR}"
systemctl restart exim4

echo -e "${GREEN}### Envoi d'un mail de test${NOCOLOR}"
echo -e "${RED}### ATTENDRE 20 sec${NOCOLOR}"
echo "Ceci est un mail de test." | mail -s Test_Envoi_Mail_$dns $admin_email
sleep 20
tail -20 /var/log/exim4/mainlog
