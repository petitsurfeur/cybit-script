#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e "${GREEN}### Copie du fichier Update dans /root/${NOCOLOR}"
cp update /root/
chmod +x /root/update
