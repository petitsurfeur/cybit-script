#!/bin/bash

apt install ufw
cp ./Firewall.sh /etc/init.d/
chmod +x /etc/init.d/Firewall.sh
vi /etc/init.d/Firewall.sh
