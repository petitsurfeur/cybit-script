#!/bin/bash
set -e

echo ""
echo "### Conf de /etc/network/interfaces"
if [ ! -f /etc/network/interfaces.SAVE ]; then
 cp /etc/network/interfaces /etc/network/interfaces.SAVE
fi

cat << 'EOF' >> /etc/network/interfaces
#
# Creation de vmbr2
source /etc/network/interfaces.d/*.cfg
EOF


echo ""
echo "### Ajout de l'interface vmbr2"
cp interfaces.d/vmbr2.cfg /etc/network/interfaces.d/

echo ""
echo "activer le bridge vmbr2"
ifup vmbr2
