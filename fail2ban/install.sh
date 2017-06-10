#!/bin/bash

echo "Installation de Fail2ban"
apt install fail2ban --yes

echo "Configuration de jail.conf"
if [ ! -f /etc/fail2ban/jail.conf.SAVE ]; then
 cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.SAVE
fi

sed -i -e 's/^#*Port.*/Port 2022/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*ignoreip =.*/ignoreip = 127.0.0.1/8 home.cybtech.net/' '/etc/fail2ban/jail.conf'
sed -i -e 's/^#*bantime =.*/bantime = 864000/' '/etc/fail2ban/jail.conf'
