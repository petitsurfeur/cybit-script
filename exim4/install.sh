#!/bin/bash

echo "Installation d'Exim4"
apt install exim4 --yes

if [ ! -f /etc/exim4/update-exim4.conf.conf.SAVE ]; then
 cp /etc/exim4/update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf.SAVE
fi

echo "Copie du fichier de conf"
cp update-exim4.conf.conf /etc/exim4/

echo "Mise-à-jour du fichier /etc/mailname"
echo rhea.cybtech.net > /etc/mailname

echo "Redémarrage d'Exim4"
service exim4 restart

echo "Envoi d'un mail de test"
echo "Ceci est un mail de test." | mail -s Test_Envoi_Mail fremaud@numericable.com
