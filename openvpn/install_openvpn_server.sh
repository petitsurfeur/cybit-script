#!/bin/bash
set -e

echo "### Installation de OpenVPN"
apt install -y openvpn easy-rsa

echo ""
echo "### Creation du dossier /etc/openvpn/keys" 
mkdir /etc/openvpn/keys
cp /usr/share/easy-rsa /etc/openvpn -r

echo ""
echo "### Configuration du fichier vars"
vi /etc/openvpn/easy-rsa/vars

echo ""
echo "### Creation des cles"
cd /etc/openvpn/easy-rsa
source vars
./clean-all
./build-ca
./build-key-server server

echo ""
echo "### Redémarrage de Rsyslog"
systemctl restart rsyslog.service

echo ""
echo "### Mise en place la rotation des logs"
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
echo "### Si hote Proxmox > Modifier DEFAULT_FORWARD_POLICY=ACCEPT dans /etc/default/ufw"
