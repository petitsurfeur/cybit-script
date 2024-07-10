#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Copie du fichier System_Update dans /root/${NOCOLOR}"
cp system_update /root/
chmod +x /root/system_update


echo ""
echo -e "${GREEN}### Planification Cron de system_update${NOCOLOR}"
if [ ! -f /etc/cron.d/update ]; then
  cat << 'EOF' > /etc/cron.d/system_update
# cron entry for System_Update
50 17 * * * root if test -x /root/system_update; then /root/system_update > /dev/null --cron; else true; fi
EOF
fi


if [ ! -f /etc/cron.d/reboot ]; then
  cat << 'EOF' > /etc/cron.d/reboot
# cron entry for reboot
# At 6:30 AM // Choose the day
# MIN HOUR DAY MONTH
30 06 13 14 * root systemctl reboot
EOF
fi




echo ""
echo -e "${GREEN}### Mise en place des DNS OPENDNS dans resolv.conf${NOCOLOR}"
if [ ! -f /etc/resolv.conf.SAVE ]; then
 cp /etc/resolv.conf /etc/resolv.conf.SAVE
fi

sed -i '/^nameserver/d' /etc/resolv.conf

cat << 'EOF' >> /etc/resolv.conf
nameserver 127.0.0.1
nameserver 9.9.9.9
nameserver 9.9.9.11
EOF

