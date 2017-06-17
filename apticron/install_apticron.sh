#!/bin/bash
set -e

echo ""
echo "### Installation d'Apticron"
apt install apticron --yes

if [ ! -f /etc/apticron/apticron.conf.SAVE ]; then
 cp /etc/apticron/apticron.conf /etc/apticron/apticron.conf.SAVE
fi

echo ""
echo "### Parametrage du fichier de Conf"
sed -i -e 's/^#*EMAIL=.*/EMAIL="admin@cybtech.net"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^# NOTIFY_NO_UPDATES="0"/NOTIFY_NO_UPDATES="1"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^# CUSTOM_FROM=""/CUSTOM_FROM="rhea@cybtech.net"/' '/etc/apticron/apticron.conf'

echo ""
echo "### Modification du Cron dans /etc/cron.d/apticron"
cat << 'EOF' > /etc/cron.d/apticron
# cron entry for apticron

39 17 * * * root if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi
EOF

