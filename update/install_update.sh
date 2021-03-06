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
echo -e "${GREEN}### Planification Cron de Update${NOCOLOR}"
if [ ! -f /etc/cron.d/update ]; then
  cat << 'EOF' > /etc/cron.d/system_update
# cron entry for System_Update
50 17 * * * root if test -x /root/system_update; then /root/system_update > /dev/null --cron; else true; fi
EOF
fi

echo ""
echo -e "${GREEN}### Copie du fichier resolv.conf${NOCOLOR}"
echo -e "${GREEN}### Serveurs DNS OpenDNS${NOCOLOR}"
if [ ! -f /etc/resolv.conf.SAVE ]; then
 cp /etc/resolv.conf /etc/resolv.conf.SAVE
fi

cat << 'EOF' > /etc/resolv.conf
nameserver 127.0.0.1
nameserver 208.67.222.222
nameserver 208.67.220.222
EOF

