#!/bin/sh

echo ""
echo "### Script pour l'Hote Proxmox"
echo "### Configuration de l'interface vmbr2"

echo "### Penser a creer le bridge Linux vmbr2 dans l'interface avant"
pause

echo ""
echo "### Copie de la config pour vmbr2"
cat << 'EOF' >> /etc/network/interfaces
auto vmbr2
iface vmbr2 inet static
        address  192.168.10.254
        netmask  255.255.255.0
        bridge_ports none
        bridge_stp off
        bridge_fd 0
        post-up echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up iptables -t nat -A POSTROUTING -s '192.168.10.0/24' -o vmbr0 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '192.168.10.0/24' -o vmbr0 -j MASQUERADE

## Pour la VM Hades KO
        post-up iptables -t nat -A PREROUTING -i vmbr0 -p tcp --dport 2122 -j DNAT --to 192.168.10.10:22
        post-down iptables -t nat -D PREROUTING -i vmbr0 -p tcp --dport 2122 -j DNAT --to 192.168.10.10:22
## Pour le CT Seedbox OK
post-up iptables -t nat -A PREROUTING -i vmbr0 -p tcp --dport 2222 -j DNAT --to 192.168.10.20:22
post-down iptables -t nat -D PREROUTING -i vmbr0 -p tcp --dport 2222 -j DNAT --to 192.168.10.20:22
EOF
