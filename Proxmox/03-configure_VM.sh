#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

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

echo ""
echo -e " ${green}### Parametrage des DNS{$NOCOLOR}"
cat << 'EOF' > /etc/resolv.conf
nameserver 127.0.0.1
nameserver 185.121.177.177
nameserver 169.237.202.202
EOF

echo ""
echo -e " ${GREEN}### Ajout des Repos${NOCOLOR}"
cat << 'EOF' >> /etc/apt/sources.list
# Debian Stretch, dépôt principal + paquets non libres
deb http://deb.debian.org/debian/ stretch main contrib non-free
# Debian Stretch, mises-à-jour de sécurité + paquets non libres
deb http://security.debian.org/ stretch/updates main contrib non-free
# Debian stretch, mises-à-jour "volatiles" + paquets non libres
deb http://deb.debian.org/debian/ stretch-updates main contrib non-free
EOF
