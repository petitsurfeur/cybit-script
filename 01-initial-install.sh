#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

set -e
#
# #################################################################
#
# Written to be used on 64 bits computers
# Author            : Petitsurfeur
# Website           : http://www.petitsurfeur.net
#
# Modified by       : 
# Version           : v2.1
# Start date        : 16/06/2017
# Last modified date: 21/02/2018
#
# #################################################################

###################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###################################################################

echo ""
echo -e "${GREEN}### Configuration du Système${NOCOLOR}"

  read -p "S'agit-il d'un serveur Proxmox (desactiver l'apt source pve-enterprise.list) [O/n) ? " proxmox_choice
    if [[ "$proxmox_choice" = 'O' ]] && [ -f /etc/apt/sources.list.d/pve-enterprise.list ]; then
      mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
    fi

echo ""
echo -e "${GREEN}### Ajustement de l'heure${NOCOLOR}"

  if [ ! -f /etc/localtime.SAVE ]; then
    mv /etc/localtime /etc/localtime.SAVE 
    ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
  fi
  date

echo ""
echo -e "--> Actuellement le nom de machine est "${RED}$(hostname -s)${NOCOLOR}" et le Full Name est "${RED}$(hostname -f)${NOCOLOR}""   
  read -p "Voulez-vous configurer le hostname [O/n] ? " hostname_conf
    if [[ "$hostname_conf" = 'O' ]]; then
      ActualFullHostname=$(hostname -f)
      IpAddr=$(hostname -i)
      ActualServerName=$(hostname -s)

      read -p "Nom du serveur (ex: tatooine) : " server_name
      read -p "Nom de domaine utilise (ex: dns.net) : " dns
      read -p "DNS complet (ex: tatooine.dns.net) : " fqdn

      echo $fqdn > /etc/hostname
      echo $dns > /etc/mailname

      sed -i -e 's/'"$ActualFullHostname"'/'"$fqdn"'/' '/etc/hosts'
      sed -i -e 's/'"$ActualServerName"'/'"$server_name"'/' '/etc/hosts'
      hostname -F /etc/hostname
    fi

echo ""    
  read -p "Voulez-vous ajouter/parametrer un utilisateur [O/n] ? " user_choice
    if [[ "$user_choice" = 'O' ]]; then
      read -p "Quel est le nom d'utilisateur (ex: admin) : "  user_add
        if [ ! -d /home/$user_add/ ]; then
          adduser $user_add
          usermod -a -G adm,sudo,www-data $user_add
      echo -e "L'utilisateur $user_add a ete cree et ajoute aux groupes adm, sudo et www-data"
      else echo -e "L'utilisateur $user_add existe deja et il a ete ajoute aux groupes adm, sudo et www-data"
      usermod -a -G adm,sudo,www-data $user_add
      fi
    fi

echo ""
echo -e "${GREEN}### Mise-a-jour du systeme${NOCOLOR}"
  read -p "Voulez-vous lancer la mise-a-jour du systeme [O/n] ? " upgrade_choice
    if [[ "$upgrade_choice" = 'O' ]]; then
      apt -y install sudo                          
      sudo apt update -y && sudo apt upgrade -y
    sleep 2
    fi

echo ""
echo -e "${GREEN}### Installation des paquets utiles${NOCOLOR}"
  packages='unrar-free unzip hardinfo hwinfo htop sysv-rc-conf locate git curl net-tools'
  echo -e "Les paquets utiles sont :  $packages"
  read -p "Voulez-vous installer les paquets utiles [O/n] ? " packages_choice
    if [[ "$packages_choice" = 'O' ]]; then
      sudo apt install -y $packages
    sleep 2
    fi

echo ""
echo -e "${GREEN}################################################################"
echo "###                 Pre-requis installes                     ###"
echo -e "################################################################${NOCOLOR}"
echo ""
sleep 2

echo ""
echo -e "${GREEN}### Configuration de GIT avec des couleurs${NOCOLOR}"
read -p "Voulez-vous installer Git [O/n] : " git_install
  if [[ "$git_install" = 'O' ]]; then
    read -p "Utilisateur Git : " git_user
    read -p "Email pour Git : " git_email
      if [ ! -d /$git_folder]; then
	mkdir $git_folder && cd /$git_folder
      fi
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto
    git config --global user.name $git_user
    git config --global user.mail $git_email

# git clone https://github.com/petitsurfeur/cybit-script.git

    cd $git_folder/cybit-script/update/ && ./install_update.sh
  fi

echo ""
echo -e "${GREEN}### Installation et configuration des outils tiers${NOCOLOR}"

read -p "--> Dossier d'installation du Repo GIT (ex: /opt/Git/): " git_folder

echo ""
read -p "Voulez-vous planifier la mise a jour quotidienne du Systeme ? (Copie du script update dans /root) [O/n] " update_install_script
  if [[ "$update_install_script" = 'O' ]]; then
        cd $git_folder/cybit-script/update/ && ./install_update.sh
  fi

echo ""
read -p "Voulez-vous installer Vim [O/n] ? " vim_choice
  if [[ "$vim_choice" = 'O' ]]; then
        cd $git_folder/cybit-script/vim/ && ./install_vim.sh
  fi

echo ""
read -p "Voulez-vous installer SSH [O/n] ? " ssh_choice
  if [[ "$ssh_choice" = 'O' ]]; then
        cd $git_folder/cybit-script/ssh/ && ./install_ssh.sh
  fi

echo ""
read -p "Voulez-vous configurer .bashrc [O/n] ? " bashrc_choice
  if [[ "$bashrc_choice" = 'O' ]]; then
        cd $git_folder/cybit-script/bashrc && ./install_bashrc.sh
  fi

echo ""
read -p "Voulez-vous installer Exim4 [O/n] ? " exim4_choice
  if [[ "$exim4_choice" = 'O' ]]; then
        cd $git_folder/cybit-script/exim4 && ./install_exim4.sh
  fi

echo ""
read -p "Voulez-vous installer Apticron [O/n] ? " apticron_choice
  if [[ "$apticron_choice" = 'O' ]]; then
        cd $git_folder/cybit-script/apticron && ./install_apticron.sh
  fi

echo ""
read -p "Voulez-vous installer Fail2ban [O/n] ? " fail2ban_choice
  if [[ "$fail2ban_choice" = 'O' ]]; then
         cd $git_folder/cybit-script/fail2ban && ./install_fail2ban.sh
  fi

echo ""
read -p "Voulez-vous installer  UFW [O/n] ? " ufw_choice
  if [[ "$ufw_choice" = 'O' ]]; then
         cd $git_folder/cybit-script/firewall && ./install_firewall.sh
  fi

echo ""
read -p "Voulez-vous installer OpenVPN [O/n] ? " openvpn_choice
  if [[ "$openvpn_choice" = 'O' ]]; then
         cd $git_folder/cybit-script/openvpn && ./install_openvpn_server.sh
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

