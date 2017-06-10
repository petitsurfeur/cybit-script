#!/bin/bash

apt install apticron --yes

if [ ! -f /etc/apticron/apticron.conf.SAVE ]; then
 cp /etc/apticron/apticron.conf /etc/apticron/apticron.conf.SAVE
fi

sed -i -e 's/^#*EMAIL=.*/EMAIL="admin@cybtech.net"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^#*NOTIFY_NO_UPDATES="0"/NOTIFY_NO_UPDATES="1"/' '/etc/apticron/apticron.conf'
sed -i -e 's/^#*CUSTOM_FROM=""/CUSTOM_FROM="rhea@cybtech.net"/' '/etc/apticron/apticron.conf'
