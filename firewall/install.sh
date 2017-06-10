#!/bin/bash

echo "Installation de UFW"
apt install ufw

echo "Copie du fichier contenant les règles"
cp ./Firewall.sh /etc/init.d/
chmod +x /etc/init.d/Firewall.sh

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
