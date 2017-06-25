#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo -e "${GREEN}### Installation d'Exim4${NOCOLOR}"
apt install -y exim4

if [ ! -f /etc/exim4/update-exim4.conf.conf.SAVE ]; then
 cp /etc/exim4/update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf.SAVE
fi

echo -e "${GREEN}### Copie du fichier de conf${NOCOLOR}"
cp update-exim4.conf.conf /etc/exim4/

echo -e "${GREEN}### Mise-à-jour du fichier /etc/mailname${NOCOLOR}"
echo rhea.cybtech.net > /etc/mailname

echo -e "${GREEN}### Redémarrage d'Exim4${NOCOLOR}"
service exim4 restart

echo -e "${GREEN}### Envoi d'un mail de test${NOCOLOR}"
echo "echo "Ceci est un mail de test." | mail -s Test_Envoi_Mail mail@test.fr"
