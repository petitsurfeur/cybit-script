#!/bin/sh

# set -e

echo ""
echo "###  Script pour la configuration d'un CT"
echo "### Connaitre le nom de l'interface a utiliser"
ls /sys/class/net

echo ""
echo "### Sauvegarde de /etc/network/interfaces"
if [ ! -f /etc/network/interfaces.SAVE ]; then
 cp /etc/network/interfaces /etc/network/interfaces.SAVE
fi

echo ""
echo "### Copie des infos pour l'interface eth0"
cat << 'EOF' >> /etc/network/interfaces
auto eth0
    iface eth0 inet static
    address 192.168.10.20
    gateway 192.168.10.254
    netmask 255.255.255.0
    broadcast 192.168.10.255
EOF
