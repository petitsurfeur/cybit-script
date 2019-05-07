#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

#read -p "Email du destinataire (admin@xx.xx) : " dest_email
#read -p "Email de l'expediteur : " sender_email
read -p "Machines a Whitelister (separer les IP par des espaces) : " whitelist


echo ""
echo -e "${GREEN}### Installation de Fail2ban${NOCOLOR}"
apt install -y fail2ban

echo ""
echo -e "${GREEN}### Configuration de jail.conf${NOCOLOR}"
if [ ! -f /etc/fail2ban/jail.conf.SAVE ]; then
 cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.SAVE
fi

if [ -f /etc/fail2ban/jail.d/defaults-debian.conf ]; then
 mv /etc/fail2ban/jail.d/defaults-debian.conf /etc/fail2ban/jail.d/defaults-debian.conf.SAVE
fi

echo ""
echo -e "${GREEN}### Configuration du fichier jail.local${NOCOLOR}"
cp jail.local /etc/fail2ban/

sed -i -e 's/^#*ignoreip.*/ignoreip = 127.0.0.1\/8 '"$whitelist"' /' '/etc/fail2ban/jail.local'
sed -i -e 's/^#*bantime  = 600/bantime = 864000/' '/etc/fail2ban/jail.local'
sed -i -e 's/^#*findtime  =.*/findtime = 6000/' '/etc/fail2ban/jail.local'
sed -i -e 's/^#*maxretry =.*/maxretry = 3/' '/etc/fail2ban/jail.local'
sed -i -e 's/^#*destemail =.*/destemail = '"$admin_email"' /' '/etc/fail2ban/jail.local'
sed -i -e 's/^#*sendername =.*/sendername = Fail2Ban - '"$(hostname -s)"' /' '/etc/fail2ban/jail.local'
sed -i -e 's/^#*sender =.*/sender = '"$server_email"' /' '/etc/fail2ban/jail.local'
sed -i -e 's/^#*action = %(action_)s/action = %(action_mwl)s/' '/etc/fail2ban/jail.local'

echo ""
echo -e "${GREEN}### Copie des filtres${NOCOLOR}"
cp filter.d/* /etc/fail2ban/filter.d/

echo ""
echo -e "${GREEN}### Redemarrage de Fail2Ban${NOCOLOR}"
service fail2ban restart
fail2ban-client status

echo ""
echo -e "${RED}### Penser a parametrer /etc/fail2ban/jail.conf et supprimer les regles inutiles${NOCOLOR}"
