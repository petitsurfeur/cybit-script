#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e

# Check if root
#if [[ "$EUID" -ne 0 ]];
#then
#    echo -e "\e[1;31mDesole, vous devez etre ROOT !\e[0m"
#  exit
#fi


if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null; then
    echo -e "${GREEN}ZSH est installe\n${NOCOLOR}"
else
    if sudo apt install -y zsh git wget || sudo pacman -S zsh git wget || sudo dnf install -y zsh git wget || sudo yum install -y zsh git wget || sudo brew install git zsh wget || pkg install git zsh wget ; then
        echo -e "${GREEN}zsh wget et git sont installes\n${NOCOLOR}"
    else
        echo -e "${RED}Veuillez installer les paquest suitants, puis reessayer: zsh git wget \n${NOCOLOR}" && exit
    fi
fi

if [ -f ~/.zshrc ]; then
    mv -n ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d") # backup .zshrc
    echo -e "${GREEN}Le fichier courant .zshrc est sauvegarde en .zshrc-backup-date\n{NOCOLOR}"
fi

echo -e "${GREEN}### Installation du framework oh-my-zsh\n${NOCOLOR}"
if [ -d ~/.oh-my-zsh ]; then
    echo -e "${GREEN}Le framework oh-my-zsh est deja installe\n${NOCOLOR}"
else
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

cp -f .zshrc ~/

mkdir -p ~/.quickzsh       # external plugins, things, will be instlled in here

if [ -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]; then
    cd ~/.oh-my-zsh/plugins/zsh-autosuggestions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-completions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

if [ -d ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    cd ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi


# INSTALL FONTS

echo -e "${GREEN}### Installation des polices Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono\n${NOCOLOR}"

wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf -P ~/.fonts/
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFontMono-Regular.ttf -P ~/.fonts/
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontMono-Regular.ttf -P ~/.fonts/

fc-cache -fv ~/.fonts


if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

if [ -d ~/.quickzsh/fzf ]; then
    cd ~/.quickzsh/fzf && git pull
    ~/.quickzsh/fzf/install --all --key-bindings --completion --no-update-rc #--64
else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.quickzsh/fzf
    ~/.quickzsh/fzf/install --all --key-bindings --completion --no-update-rc #--64
fi

if [ -d ~/.oh-my-zsh/custom/plugins/k ]; then
    cd ~/.oh-my-zsh/custom/plugins/k && git pull
else
    git clone --depth 1 https://github.com/supercrabtree/k ~/.oh-my-zsh/custom/plugins/k
fi

if [ -d ~/.quickzsh/marker ]; then
    cd ~/.quickzsh/marker && git pull
else
    git clone --depth 1 https://github.com/pindexis/marker ~/.quickzsh/marker
fi

if ~/.quickzsh/marker/install.py; then
    echo -e "{$GREEN}### Installed Marker\n{$NOCOLOR}"
else
    echo -e "{$RED}Marker Installation Had Issues\n{$NOCOLOR}"
fi


# if git clone --depth 1 https://github.com/todotxt/todo.txt-cli.git ~/.quickzsh/todo; then :
# else
#     cd ~/.quickzsh/todo && git fetch --all && git reset --hard origin/master
# fi
# mkdir ~/.quickzsh/todo/bin ; cp -f ~/.quickzsh/todo/todo.sh ~/.quickzsh/todo/bin/todo.sh # cp todo.sh to ./bin so only it is included in $PATH
# #touch ~/.todo/config     # needs it, otherwise spits error , yeah a bug in todo
# ln -s ~/.quickzsh/todo ~/.todo
if [ ! -L ~/.quickzsh/todo/bin/todo.sh ]; then
    echo -e "{$GREEN}### Installing todo.sh in ~/.quickzsh/todo\n{$NOCOLOR}"
    mkdir -p ~/.quickzsh/todo/bin
    wget -q --show-progress "https://github.com/todotxt/todo.txt-cli/releases/download/v2.11.0/todo.txt_cli-2.11.0.tar.gz" -P ~/.quickzsh/
    tar xvf ~/.quickzsh/todo.txt_cli-2.11.0.tar.gz -C ~/.quickzsh/todo --strip 1 && rm ~/.quickzsh/todo.txt_cli-2.11.0.tar.gz
    ln -s ~/.quickzsh/todo/todo.sh ~/.quickzsh/todo/bin/todo.sh     # so only .../bin is included in $PATH
    ln -s ~/.quickzsh/todo/todo.cfg ~/.todo.cfg     # it expects it there or ~/todo.cfg or ~/.todo/config
else
    echo -e "{$GREEN}todo.sh is already instlled in ~/.quickzsh/todo/bin/\n{$NOCOLOR}"
fi

if [[ $1 == "--cp-hist" ]] || [[ $1 == "-c" ]]; then
    echo -e "{$GREEN}\nCopying bash_history to zsh_history\n{$NOCOLOR}"
    if command -v python &>/dev/null; then
        wget -q --show-progress https://gist.githubusercontent.com/muendelezaji/c14722ab66b505a49861b8a74e52b274/raw/49f0fb7f661bdf794742257f58950d209dd6cb62/bash-to-zsh-hist.py
        cat ~/.bash_history | python bash-to-zsh-hist.py >> ~/.zsh_history
    else
        if command -v python3 &>/dev/null; then
            wget -q --show-progress https://gist.githubusercontent.com/muendelezaji/c14722ab66b505a49861b8a74e52b274/raw/49f0fb7f661bdf794742257f58950d209dd6cb62/bash-to-zsh-hist.py
            cat ~/.bash_history | python3 bash-to-zsh-hist.py >> ~/.zsh_history
        else
            echo "{$RED}Python is not installed, can't copy bash_history to zsh_history\n{$NOCOLOR}"
        fi
    fi
else
    echo -e "{$RED}\nNot copying bash_history to zsh_history, as --cp-hist or -c is not supplied\n{$NOCOLOR}"
fi


# source ~/.zshrc
echo -e "{$GREEN}\nSudo access is needed to change default shell\n{$NOCOLOR}"

if chsh -s $(which zsh) && /bin/zsh -i -c upgrade_oh_my_zsh; then
    echo -e "{$GREEN}Installation Successful, exit terminal and enter a new session{$NOCOLOR}"
else
    echo -e "{$RED}Something is wrong{$NOCOLOR}"
fi
exit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
echo -e "{$GREEN} Pour configurer le prompt, lancer 'p10k configure'{$NOCOLOR}"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Definir zsh par defaut
chsh -s /bin/zsh



#read -p "!!!! Le script ne fontionne pas parfaitement !!! Voulez-vous installer Zsh [O/n] ? " zsh_install_choice
#  if [[ "$zsh_install_choice" = 'O' ]]; then


#    if [ -d /root/.oh-my-zsh/ ]; then
#      read -p "Zsh est deja present, souhaitez-vous le reinstaller [O/n] ? " zsh_reinstall_choice
#      if [[ "$zsh_reinstall_choice" = O ]]; then
#	apt remove zsh -y
# 	rm ~/.oh-my-zsh/ ~/.zshrc ~/.shell.pre-oh-my-zsh ~/.zsh_history -Rf
#      fi



#    apt install wget curl git -y
#    apt install zsh -y
#    usermod -s $(which zsh) root

#    echo -e ""
#    read -p "${GREEN}### Voulez-vous installer oh-my-zsh framework [O/n] ?${NOCOLOR} " oh-my-zsh_choice
#    echo -e "${RED}### Une fois installe, relancez ce script pour installer les plugins${NOCOLOR}"
#      if [[ "oh-my-zsh_choice" = 'O' ]]; then
#        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#      fi

#    if [ -d /root/.oh-my-zsh/ ]; then
#      read -p "Zsh est deja present, souhaitez-vous le reinstaller [O/n] ? " zsh_reinstall_choice
#      if [[ "$zsh_reinstall_choice" = O ]]; then
#	rm /root/.oh-my-zsh/ /root/.zshrc -Rf

#        echo -e "${GREEN}### Installation des prerequis${NOCOLOR}"

#        usermod -s $(which zsh) root

#        echo -e "${GREEN}### Installation de oh-my-zsh framework${NOCOLOR}"
#        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#      fi

#    apt install zsh -y
#    usermod -s $(which zsh) root

#    fi
#  fi

#read -p "Voulez-vous configurer le theme Powerlevel10k [O/n] ? " zsh_theme_choice
##    echo -e "le dossier est ${ZSH}"
#  if [[ "$zsh_theme_choice" = 'O' ]]; then
#    echo -e "${GREEN}### Application du theme PowerLevel110k${NOCOLOR}"
#    if [ -d "/root/.oh-my-zsh/themes/powerlevel10k/" ]; then
#      rm /root/.oh-my-zsh/themes/powerlevel10k -R

#    fi
#    git clone https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/themes/powerlevel10k/
#    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting    

#sed -i -e 's/^#*ZSH_THEME.*/ZSH_THEME="bira"'
#    sed -i -e 's/^ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' '/root/.zshrc'
#    sed -i -e 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)/' '/root/.zshrc'

#cat << 'EOF' >> /root/.zshrc
#alias ls='ls --color=auto'
#alias ll='ls -alFh'

#LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
#LS_COLORS='di=1;104:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
#export LS_COLORS
#EOF
#  fi

#  source /root/.zshrc

#read -p "autre compte a appliquer: " zsh_otheraccount
#cp "$HOME"/.zshrc /$zsh_otheraccount && chown $zsh_otheraccount:$zsh_otheraccount /home/$zsh_otheraccount/.zshrc


