#!/bin/bash

echo "Installation de UFW"
apt install ufw

echo "Remplacement du fichier" 
if [ ! -f /etc/ufw/before.rules.SAVE ]; then
 cp /etc/ufw/before.rules /etc/ufw/before.rules.SAVE
fi

cp before.rules /etc/ufw/

echo "Copie du fichier contenant les règles"
cp FirewallRules.sh /etc/init.d/
chmod +x /etc/init.d/FirewallRules.sh
sh /etc/init.d/FirewallRules.sh

echo "Desactiver les logs UFW dans syslog et kern.log"
cat << 'EOF' > /etc/rsyslog.d/20-ufw.conf
# Log kernel generated UFW log messages to file
:msg,contains,"[UFW " /var/log/ufw.log
 
# Uncomment the following to stop logging anything that matches the last rule.
# Doing this will stop logging kernel generated UFW log messages to the file
# normally containing kern.* messages (eg, /var/log/kern.log)
& stop
EOF

echo "Redémarrage de Rsyslog"
systemctl restart rsyslog.service

echo "Mettre en place la rotation des logs"
cp firewall /etc/logrotate.d/
