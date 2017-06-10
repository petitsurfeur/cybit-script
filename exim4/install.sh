#!/bin/bash

apt install exim4 --yes

if [ ! -f /etc/exim4/update-exim4.conf.conf.SAVE ]; then
 cp /etc/exim4/update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf.SAVE
fi

cp update-exim4.conf.conf /etc/exim4/

echo rhea.cybtech.net > /etc/mailname

service exim4 restart

echo "Ceci est un mail de test." | mail -s Test_Envoi_Mail fremaud@numericable.com
