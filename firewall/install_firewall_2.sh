#!/bin/bash
set -e

echo ""
echo "### Modification de /etc/sysctl.conf"

if [ ! -f /etc/sysctl.conf.SAVE ]; then
 cp /etc/sysctl.conf /etc/sysctl.conf.SAVE
fi

echo ""
echo "### Copie des 2 dernieres lignes"
cat << 'EOF' >> /etc/sysctl.conf

# IP Forwarding pour VM et CT
net.ipv4.conf.default.forwarding=1
net.ipv4.conf.all.forwarding=1
EOF

echo ""
echo "### Redémarrage de Rsyslog"
