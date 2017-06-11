#!/bin/bash

echo "Installation de Fail2ban"
apt install fail2ban --yes

echo "Configuration de jail.conf"
if [ ! -f /etc/fail2ban/jail.conf.SAVE ]; then
 cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.SAVE
fi

sed -i -e 's/^#*ignoreip.*/ignoreip = 127.0.0.1\/8 XXX.cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*bantime =.*/bantime = 864000/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*findtime =.*/findtime = 6000/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*maxretry =.*/maxretry = 3/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*destemail =.*/destemail = XXX@cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*sendername =.*/sendername = Fail2Ban - XXX/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*sender =.*/sender = XXX@cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*action =.*/action = %(action_mwl)s/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*port = ssh/port = 22,2022/' '/etc/fail2ban/jail.conf'


echo " Copie des fichiers dans /"
echo "Configuration de jail.local"
