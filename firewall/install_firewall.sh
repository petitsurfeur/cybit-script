#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo -e "${GREEN}### Installation de UFW${NOCOLOR}"
apt install ufw

#echo ""
#echo -e "${GREEN}### Remplacement du fichier before.rules${NOCOLOR}" 
#if [ ! -f /etc/ufw/before.rules.SAVE ]; then
# cp /etc/ufw/before.rules /etc/ufw/before.rules.SAVE
#fi
#cp before.rules /etc/ufw/

echo ""
echo -e "${GREEN}### Copie du fichier contenant les règles${NOCOLOR}"
cp FirewallRules /etc/init.d/
chmod +x /etc/init.d/FirewallRules
sh /etc/init.d/FirewallRules

echo ""
echo -e "${GREEN}### Desactivation des logs UFW dans syslog et kern.log${NOCOLOR}"
cat << 'EOF' > /etc/rsyslog.d/20-ufw.conf
# Log kernel generated UFW log messages to file
:msg,contains,"[UFW " /var/log/ufw.log
 
# Uncomment the following to stop logging anything that matches the last rule.
# Doing this will stop logging kernel generated UFW log messages to the file
# normally containing kern.* messages (eg, /var/log/kern.log)
& stop
EOF

echo ""
echo -e "${GREEN}### Redémarrage de Rsyslog${NOCOLOR}"
systemctl restart rsyslog.service

echo ""
echo -e "${GREEN}### Mise en place la rotation des logs${NOCOLOR}"
cat << 'EOF' > /etc/logrotate.d/ufw
/var/log/ufw.log {
        weekly
        rotate 12
        compress
        delaycompress
        missingok
        notifempty
        create 644 syslog adm
}
EOF

echo ""
echo -e "${RED}### Si hote Proxmox > Modifier DEFAULT_FORWARD_POLICY=ACCEPT dans /etc/default/ufw${NOCOLOR}"
