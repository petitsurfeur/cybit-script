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
echo -e "${RED}### Pour personnaliser le message d'accueil > http://patorjk.com/software/taag/#p=display&f=Colossal&t=Nom%20du%20Serveur${NOCOLOR}"