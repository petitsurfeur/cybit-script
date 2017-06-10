#!/bin/bash
#Author: petitsurfeur
#This Script is a part of cybit-script
#More informations:
# Configure SSH
#apt update
apt install openssh-server

if [ ! -f /etc/ssh/sshd_config.SAVE ]; then
 cp /etc/ssh/sshd_config /etc/ssh/sshd_config.SAVE
fi

sed -i -e 's/^#*Port.*/Port 2022/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*LoginGraceTime.*/LoginGraceTime 30/' '/etc/ssh/sshd_config'
sed -i -e 's/^#*PermitRootLogin.*/PermitRootLogin no/' '/etc/ssh/sshd_config'
sed -i 's/^#*MaxStartups.*$/MaxStartups 3:50:10/g' /etc/ssh/sshd_config


#service sshd restart
