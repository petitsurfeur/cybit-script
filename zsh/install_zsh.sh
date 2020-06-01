#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

# Check if root
if [[ "$EUID" -ne 0 ]];
then
    echo -e "\e[1;31mDesole, vous devez etre ROOT !\e[0m"
  exit
fi


read -p "!!!! Le script ne fontionne pas parfaitement !!! Voulez-vous installer Zsh [O/n] ? " zsh_install_choice
  if [[ "$zsh_install_choice" = 'O' ]]; then
    if [ -d /root/.oh-my-zsh/ ]; then
      read -p "Zsh est deja present, souhaitez-vous le reinstaller [O/n] ? " zsh_reinstall_choice
      if [[ "$zsh_reinstall_choice" = O ]]; then
	rm /root/.oh-my-zsh/ /root/.zshrc -Rf

        echo -e "${GREEN}### Installation des prerequis${NOCOLOR}"
        apt install wget curl git -y
        apt install zsh -y

        usermod -s $(which zsh) root

        echo -e "${GREEN}### Installation de oh-my-zsh framework${NOCOLOR}"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
      fi
    fi
  fi

read -p "Voulez-vous configurer le theme [O/n] ? " zsh_theme_choice
#    echo -e "le dossier est ${ZSH}"
  if [[ "$zsh_theme_choice" = 'O' ]]; then
    echo -e "${GREEN}### Application du theme PowerLevel110k${NOCOLOR}"
    if [ -d "/root/.oh-my-zsh/themes/powerlevel10k/" ]; then
      rm /root/.oh-my-zsh/themes/powerlevel10k -R

    fi
    git clone https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/themes/powerlevel10k/
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting    

#sed -i -e 's/^#*ZSH_THEME.*/ZSH_THEME="bira"'
    sed -i -e 's/^ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' '/root/.zshrc'
    sed -i -e 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)/' '/root/.zshrc'

cat << 'EOF' >> /root/.zshrc
alias ls='ls --color=auto'
alias ll='ls -alFh'

#LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
LS_COLORS='di=1;104:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS
EOF
  fi

  source /root/.zshrc

read -p "autre compte a appliquer: " zsh_otheraccount
cp "$HOME"/.zshrc /$zsh_otheraccount && chown $zsh_otheraccount:$zsh_otheraccount /home/$zsh_otheraccount/.zshrc


