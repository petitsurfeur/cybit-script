#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Configuration Reseau pour OpenVPN${NOCOLOR}"

#sed -i -e 's/^#*ufw allow in openvpn\/tcp/ufw allow in openvpn\/tcp/' '/etc/init.d/FirewallRules'
#sed -i -e 's/^#*net.ipv4.ip.forward=1/net.ipv4.ip.forward=1/' '/etc/sysctl.conf'

sed -i -e '/*nat/ r before.rules.sed' '/etc/ufw/before.rules'
