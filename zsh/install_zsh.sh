#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

echo -e "${GREEN}### Installation des prerequis${NOCOLOR}"
apt install wget curl git -y
apt install zsh -y

usermod -s $(which zsh) root


echo -e "${GREEN}### Installation de oh-my-zsh framework${NOCOLOR}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


echo -e "${GREEN}### Application du theme PowerLevel110k${NOCOLOR}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

#sed -i -e 's/^#*ZSH_THEME.*/ZSH_THEME="bira"'
sed -i -e 's/^#*ZSH_THEME.*/ZSH_THEME="powerlevel10k/powerlevel10k"'
sed -i -e 's/^#plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)'
source ~/.zshrc


cat << 'EOF' > ~/.zshrc
alias ls='ls --color=auto'
alias ll='ls -alFh'

#LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
LS_COLORS='di=1;104:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS
EOF

read -p "autre compte a appliquer: " zsh_otheraccount
cp ~/.zshrc /$zsh_otheraccount && chown $zsh_otheraccount:$zsh_otheraccount $zsh_otheraccount/.zshrc


