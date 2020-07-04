#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e


echo -e "${GREEN}### Installation de Node Exporter ###${NOCOLOR}"

wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar zxvf node_exporter-1.0.1.linux-amd64.tar.gz
cd node_exporter-1.0.1.linux-amd64
cp node_exporter /usr/local/bin/

echo -e "${GREEN}### Creation du user${NOCOLOR}"
useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter


echo -e "${GREEN}### Creation du service${NOCOLOR}"
cp node_exporter.service /etc/systemd/system/node_exporter.service

echo -e "${GREEN}### Activation du service${NOCOLOR}"
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

echo -e "${GREEN}### Activation du service${NOCOLOR}"
echo -e "ufw allow in 9100/tcp comment 'NodeExporter'"
