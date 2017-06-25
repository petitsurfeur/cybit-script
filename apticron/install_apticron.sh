#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e " ${GREEN}### Installation d'Apticron${NOCOLOR}"
apt install apticron --yes

if [ ! -f /etc/apticron/apticron.conf.SAVE ]; then
 cp /etc/apticron/apticron.conf /etc/apticron/apticron.conf.SAVE
fi

echo ""
echo -e  ${GREEN}"### Parametrage du fichier de Conf${NOCOLOR}"
sed -i -e 's/^#*EMAIL=.*/EMAIL="admin@cybtech.net"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^# NOTIFY_NO_UPDATES="0"/NOTIFY_NO_UPDATES="1"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^# CUSTOM_FROM=""/CUSTOM_FROM="rhea@cybtech.net"/' '/etc/apticron/apticron.conf'

echo ""
echo -e " ${GREEN}### Modification du Cron dans /etc/cron.d/apticron${NOCOLOR}"
cat << 'EOF' > /etc/cron.d/apticron
# cron entry for apticron

39 17 * * * root if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi
EOF

