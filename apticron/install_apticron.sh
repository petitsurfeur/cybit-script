#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e " ${GREEN}### Installation d'Apticron${NOCOLOR}"

apt install apticron --yes

if [ ! -f /etc/apticron/apticron.conf ]; then
  cp /usr/lib/apticron/apticron.conf /etc/apticron
fi

if [ ! -f /etc/apticron/apticron.conf.SAVE ]; then
 cp /etc/apticron/apticron.conf /etc/apticron/apticron.conf.SAVE
fi

if [ -z ${server_email+x} ]; then
  read -p "Email de l'expediteur (serveur) (server@xx.net) : " server_email
fi

if [ -z ${admin_email+x} ]; then
  read -p "Email du destinataire (admin@xxx.xx) : " admin_email
fi



echo ""
echo -e " ${GREEN}### Parametrage du fichier de Conf${NOCOLOR}"
sed -i -e 's/^#*EMAIL=.*/EMAIL="'"$admin_email"'"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^# NOTIFY_NO_UPDATES="0"/NOTIFY_NO_UPDATES="1"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^# CUSTOM_FROM=.*/CUSTOM_FROM="'"$server_email"'"/' '/etc/apticron/apticron.conf'

echo ""
echo -e " ${GREEN}### Modification du Cron dans /etc/cron.d/apticron${NOCOLOR}"
cat << 'EOF' > /etc/cron.d/apticron
# cron entry for apticron

40 17 * * * root if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi
EOF

#echo ""
#echo -e " ${green}### Execution d'Apticron et envoi d'un mail${NOCOLOR}"
#echo -e "${RED}### ATTENDRE 20 sec${NOCOLOR}"
#systemctl restart exim4.service
#apticron
#sleep 20
#tail -20 /var/log/exim4/mainlog
