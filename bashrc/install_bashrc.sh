#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo ""
echo -e  "${GREEN}### Copie de .bash_aliases${NOCOLOR}" 
cp .bash_aliases /root/ && cp .bash_aliases /home/cybitnap/

cat << 'EOF' >> /root/.bashrc
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF

echo ""
#read -p "Nom du serveur (ex: tatooine) : " server_name
echo -e "${RED}### Pour personnaliser le message d'accueil dans /etc/motd > http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t="${server_name}" ${NOCOLOR}"
