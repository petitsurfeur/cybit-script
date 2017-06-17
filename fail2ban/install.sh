#!/bin/bash
set -e

echo "Installation de Fail2ban"
apt install -y fail2ban

echo "Configuration de jail.conf"
if [ ! -f /etc/fail2ban/jail.conf.SAVE ]; then
 cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.SAVE
fi

sed -i -e 's/^#*ignoreip.*/ignoreip = 127.0.0.1\/8 XXX.cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/bantime = 6000/bantime = 864000/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*findtime =.*/findtime = 6000/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*maxretry =.*/maxretry = 3/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*destemail =.*/destemail = XXX@cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*sendername =.*/sendername = Fail2Ban - XXX/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*sender =.*/sender = XXX@cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*action = %(action_)s/action = %(action_mwl)s/' '/etc/fail2ban/jail.conf'


echo "### Configuration du fichier jail.local"
cp jail.local /etc/fail2ban/
echo "### Copie des filtres"
cp filter.d/* /etc/fail2ban/filter.d/

echo "### Redemarrage de Fail2Ban"
service fail2ban restart
fail2ban-client status
