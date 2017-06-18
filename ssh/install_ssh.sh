#!/bin/bash
set -e

echo ""
echo "### Installation de Openssh-server"
#apt update
apt install openssh-server

if [ ! -f /etc/ssh/sshd_config.SAVE ]; then
 cp /etc/ssh/sshd_config /etc/ssh/sshd_config.SAVE
fi

echo ""
echo "### Configuration du fichier /etc/ssh/sshd_config"
sed -i -e 's/^#*Port.*/Port 2022/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*LoginGraceTime.*/LoginGraceTime 30/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*PermitRootLogin.*/PermitRootLogin no/' '/etc/ssh/sshd_config'
sed -i '/PermitRootLogin no/a\AllowUsers' '/etc/ssh/sshd_config'
sed -i -e 's/^#*MaxStartups.*$/MaxStartups 3:50:10/g' /'etc/ssh/sshd_config'

echo ""
echo "### Redemarrage du service"
service ssh restart

echo ""
echo "### Penser a modifier AllowUsers"
echo ""
