#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e " ${GREEN}### Installation de Proftpd avec TLS/SSL${NOCOLOR}"

read -p "Email du destinataire (admin) : " dest_email
read -p "Email de l'expediteur : " sender_email

apt install proftpd openssl --yes

if [ ! -f /etc/proftpd/proftpd.conf.SAVE ]; then
 cp /etc/ptoftpd/proftpd.conf /etc/proftpd/proftpd.conf.SAVE
fi

#echo ""
#echo -e " ${GREEN}### Parametrage du fichier de Conf${NOCOLOR}"
#sed -i -e 's/^#*EMAIL=.*/EMAIL="'"$dest_email"'"/' '/etc/apticron/apticron.conf'
#sed -i -e 's/^# NOTIFY_NO_UPDATES="0"/NOTIFY_NO_UPDATES="1"/' '/etc/apticron/apticron.conf'
#sed -i -e 's/^# CUSTOM_FROM=""/CUSTOM_FROM="'"$sender_email"'"/' '/etc/apticron/apticron.conf'

#echo ""
#echo -e " ${GREEN}### Modification du Cron dans /etc/cron.d/apticron${NOCOLOR}"
#cat << 'EOF' > /etc/cron.d/apticron

#echo ""
echo -e " ${green}### Installation de Proftpd terminee${NOCOLOR}"
