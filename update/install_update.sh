#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Copie du fichier Update dans /root/${NOCOLOR}"
cp update /root/
chmod +x /root/update


echo ""
echo -e "${GREEN}### Planification Cron de Update${NOCOLOR}"
if [ ! -f /etc/cron.d/update ]; then
  cat << 'EOF' > /etc/cron.d/update
# cron entry for Update

30 17 * * * root if test -x /root/update; then /root/update --cron; else true; fi
EOF
fi

echo ""
echo -e "${GREEN}### Copie du fichier resolv.conf${NOCOLOR}"
cat << 'EOF' > /etc/resolv.conf
nameserver 127.0.0.1
nameserver 185.121.177.177
nameserver 169.237.202.202
EOF



