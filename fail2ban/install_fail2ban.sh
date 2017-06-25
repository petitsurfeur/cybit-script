#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Installation de Fail2ban${NOCOLOR}"
apt install -y fail2ban

echo ""
echo -e "${GREEN}### Configuration de jail.conf${NOCOLOR}"
if [ ! -f /etc/fail2ban/jail.conf.SAVE ]; then
 cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.SAVE
fi

sed -i -e 's/^#*ignoreip.*/ignoreip = 127.0.0.1\/8 XXX.cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*bantime  = 600/bantime = 864000/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*findtime =.*/findtime = 6000/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*maxretry =.*/maxretry = 3/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*destemail =.*/destemail = XXX@cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*sendername =.*/sendername = Fail2Ban - XXX/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*sender =.*/sender = XXX@cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*action = %(action_)s/action = %(action_mwl)s/' '/etc/fail2ban/jail.conf'

echo ""
echo -e "${GREEN}### Configuration du fichier jail.local${NOCOLOR}"
cp jail.local /etc/fail2ban/

echo ""
echo -e "${GREEN}### Copie des filtres${NOCOLOR}"
cp filter.d/* /etc/fail2ban/filter.d/

echo ""
echo -e "${GREEN}### Redemarrage de Fail2Ban${NOCOLOR}"
service fail2ban restart
fail2ban-client status

echo ""
echo -e "${RED}### Penser a parametrer /etc/fail2ban/jail.conf et supprimer les regles inutiles${NOCOLOR}"
