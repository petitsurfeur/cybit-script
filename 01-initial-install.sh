#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e
#
# #################################################################
#
# Written to be used on 64 bits Linux computers (Ubuntu & Debian)
# Author            : Petitsurfeur
# Website           : https://www.petitsurfeur.net
#
# Modified by       : 
# Version           : v2.5
# Start date        : 16/06/2017
# Last modified date: 02/09/2023
#
# #################################################################

###################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###################################################################

# Library Path
LIBRARYPATH=libraries

# Load Libraries
for file in $LIBRARYPATH/*.sh; do
  # Source Libraries
  source $file
done

# Check if root
if [[ "$EUID" -ne 0 ]];
then
    error "Desole, vous devez etre ROOT !"
  exit
fi

#echo ""
#header "###      System Configuration             ###"
#header "###                                       ###"
#header "###      Variables Definitions            ###"
  export script_PWD=$PWD

clear
# Ajouter infos actuels dans banner

ActualIP=$(ip a | grep brd | grep inet)

echo -e ""
echo -e "**********************************************"
echo -e "--> Actuellement le nom de machine est "${RED}$(hostname -f)${NOCOLOR}""
echo -e "--> Son IP est "${RED}$ActualIP}${NOCOLOR}""
echo -e "**********************************************"
echo -e ""

echo ""
header "###              Configure Time            ###"
  if [ ! -f /etc/localtime.SAVE ]; then
    mv /etc/localtime /etc/localtime.SAVE
    ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
  fi
  echo -e "${GREEN}L'heure systeme est ${NOCOLOR} $(date)"


echo ""
  read -p "Voulez-vous ajouter/parametrer un utilisateur [O/n] ? " user_choice
    if [[ "$user_choice" = 'O' ]]; then
      read -p "Quel est le nom d'utilisateur (ex: admin) : "  user_add
      export user_add=$user_add
      if [ ! -d /home/$user_add/ ]; then
          adduser $user_add
          usermod -a -G adm,sudo,www-data $user_add
      echo -e "${GREEN}L'utilisateur $user_add a ete cree et ajoute aux groupes adm, sudo et www-data${NOCOLOR}"
      else echo -e "${GREEN}L'utilisateur $user_add existe deja et il a ete ajoute aux groupes adm, sudo et www-data${NOCOLOR}"
      usermod -a -G adm,sudo,www-data $user_add
      fi
    fi


echo ""
header "###         System Update                 ###"
  read -p "Voulez-vous mettre a jour le systeme [O/n] ? " upgrade_choice
    if [[ "$upgrade_choice" = 'O' ]]; then
      apt update -y && apt upgrade -y
      sleep 2
    fi

echo ""
header "###    Usefull packets installation       ###"
  packages='unrar-free unzip hardinfo hwinfo htop tree locate git curl net-tools dirmngr ca-certificates gnupg iptables openssl wget curl sudo'
#echo ""
read -p "Voulez-vous installer les paquets suivants (utiles) : $packages  [O/n] ? " packages_choice
    if [[ "$packages_choice" = 'O' ]]; then
      apt-get install -y $packages
    sleep 2
    fi

echo ""
echo -e "--> Actuellement le nom de machine est "${RED}$(hostname -s)${NOCOLOR}" et le Full Name est "${RED}$(hostname -f)${NOCOLOR}""
read -p "Voulez-vous changer le hostname ou fullname ? [O/n] ? " hostname_conf_choice
  if [[ "$hostname_conf_choice" = O ]]; 
  then
    if [[ ! -f /etc/hostname.SAVE ]]; then
      cp /etc/hostname /etc/hostname.SAVE && echo $fqdn > /etc/hostname
    fi
    if [[ ! -f /etc/mailname.SAVE ]] & [[ -f /etc/mailname ]]; then
      cp /etc/mailname /etc/mailname.SAVE && echo $dns > /etc/mailname
    fi
    if [[ ! -f /etc/hosts.SAVE ]]; then
      cp /etc/hosts /etc/hosts.SAVE
    fi

    read -p "Nom du serveur (ex: tatooine) : " server_name
    read -p "Nom de domaine utilise (ex: dns.net) : " dns
    read -p "DNS complet (ex: tatooine.dns.net) : " fqdn

    read -p "Email du serveur (server@xx.net) : " server_email
    read -p "Email du destinataire (admin@xxx.xx) : " admin_email

    export server_name=$server_name
    export dns=$dns
    export fqdn=$fqdn
    export server_email=$server_email
    export admin_email=$admin_email
    export ActualFullHostname=$(hostname -f)

    hostnamectl set-hostname $fqdn

    hostname -F /etc/hostname
  
  else
   ActualFullHostname=$(hostname -f)
   ActualServerName=$(hostname -s)
  fi

echo ""
  read -p "S'agit-il d'un serveur Proxmox (modifier l'apt source pve-enterprise.list) [O/n) ? " proxmox_choice
    if [[ "$proxmox_choice" = 'O' ]] && [ -f /etc/apt/sources.list.d/pve-enterprise.list ]; then
      cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.SAVE
      sed -i -e 's/pve-enterprise/pve-no-subscription/' '/etc/apt/sources.list.d/pve-enterprise.list'
    fi


echo ""
  read -p "Voulez-vous planifier la mise a jour quotidienne du Systeme ? (Copie du script System_Update dans /root) [O/n] ?" update_install_script
    if [[ "$update_install_script" = 'O' ]]; then
      cd $script_PWD/update/ && ./install_update.sh
    fi

echo ""
  read -p "Voulez-vous installer rsyslog [O/n] ? " install_rsyslog
    if [[ "$install_rsyslog" = 'O' ]]; then
      apt install -y rsyslog
    fi


echo ""
echo -e "${GREEN}################################################################"
echo "###                 Pre-requis installes                     ###"
echo -e "################################################################${NOCOLOR}"
echo ""

echo ""
header "### Configuration de GIT avec des couleurs ###"
read -p "Voulez-vous installer/configurer Git [O/n] : " git_install
  if [[ "$git_install" = 'O' ]]; then
    read -p "Utilisateur Git : " git_user
    read -p "Email pour Git : " git_email
#    read -p "--> Dossier d'installation du Repo GIT (ex: /opt/Git_Repos): " git_folder
#    if [[ ! -d /$git_folder ]]; then
#	mkdir $git_folder && cd /$git_folder
#    fi
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto
    git config --global user.name $git_user
    git config --global user.mail $git_email

# git clone https://github.com/petitsurfeur/cybit-script.git
  fi

  echo ""
#read -p "Dossier d'installation du Repo GIT (ex: /opt/Git_Repos): " git_folder
#  if [[ ! -d /$git_folder ]]; then
#    mkdir $git_folder && cd /$git_folder
#  fi

echo ""
header "### Installation et configuration des outils tiers ###"

echo ""
read -p "Voulez-vous installer Vim [O/n] ? " vim_choice
  if [[ "$vim_choice" = 'O' ]]; then
        cd $script_PWD/vim/ && ./install_vim.sh
  fi

echo ""
read -p "Voulez-vous installer SSH Server [O/n] ? " ssh_choice
  if [[ "$ssh_choice" = 'O' ]]; then
        cd $script_PWD/ssh/ && ./install_ssh.sh
  fi

### Deprecated with Ubuntu and ZSH
#echo ""
#read -p "Voulez-vous configurer .bashrc [O/n] ? " bashrc_choice
#  if [[ "$bashrc_choice" = 'O' ]]; then
#        cd $script_PWD/bashrc && ./install_bashrc.sh
#  fi

#echo ""
#read -p "Voulez-vous installer Exim4 [O/n] ? " exim4_choice
#  if [[ "$exim4_choice" = 'O' ]]; then
#        cd $script_PWD/exim4 && ./install_exim4.sh
#  fi

echo ""
read -p "Voulez-vous installer Apticron [O/n] ? " apticron_choice
  if [[ "$apticron_choice" = 'O' ]]; then
        cd $script_PWD/apticron && ./install_apticron.sh
  fi

echo ""
read -p "Voulez-vous installer Fail2ban [O/n] ? " fail2ban_choice
  if [[ "$fail2ban_choice" = 'O' ]]; then
         cd $script_PWD/fail2ban && ./install_fail2ban.sh
  fi

echo ""
read -p "Voulez-vous installer UFW [O/n] ? " ufw_choice
  if [[ "$ufw_choice" = 'O' ]]; then
         cd $script_PWD/firewall && ./install_firewall.sh
  fi

#echo ""
#read -p "Voulez-vous installer OpenVPN [O/n] ? " openvpn_choice
#  if [[ "$openvpn_choice" = 'O' ]]; then
#         cd $script_PWD/openvpn && ./install_openvpn_server.sh
#  fi


echo ""
read -p "Voulez-vous installer Zsh [O/n] ? " zsh_choice
  if [[ "$zsh_choice" = 'O' ]]; then
         cd $script_PWD/zsh && ./install_zsh.sh
  fi


echo ""
echo -e "${GREEN}################################################################"
echo "###           Installation terminee                          ###"
echo -e "################################################################${NOCOLOR}"
echo ""
read -p "Voulez-vous redemarrer [O/n] ? " reboot
  if [[ "$reboot" = 'O' ]]; then
    shutdown -r now
  fi

