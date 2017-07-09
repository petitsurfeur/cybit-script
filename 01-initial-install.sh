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
# Website           : http://
#
# Modified by       : 
# Version           : v2
# Start date        : 16/06/2017
# Last modified date: 09/07/2017
#
# #################################################################

###################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###################################################################

echo ""
echo -e "${GREEN}### Mise-à-jour du Système${NOCOLOR}"

read -p "S'agit-il d'un serveur Proxmox (desactiver l'apt source pve-enterprise.list) [O-n) ? " proxmox_choice
  if [[ "$proxmox_choice" = 'O' ]] && [ -f /etc/apt/sources.list.d/pve-enterprise.list ]; then
    mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
  fi
  
read -p "Voulez-vous configurer le hostname et ajouter un utilisateur [O/n] ? " hostname_conf
if [[ "$hostname_conf" = 'O' ]]; then
  ActualFullHostname=$(hostname -f)
  IpAddr=$(hostname -i)
  ActualServerName=$(hostname -s)

  read -p "Nom du serveur (ex: tatooine) : " server_name
  read -p "Nom de domaine utilise (ex: dns.net) : " dns
  read -p "DNS complet (ex: tatooine.dns.net) : " fqdn
  read -p "Utilisateur a creer : " login

  echo $fqdn > /etc/hostname
  echo $dns > /etc/mailname

  sed -i -e 's/'"$ActualFullHostname"'/'"$fqdn"'/' '/etc/hosts'
  sed -i -e 's/'"$ActualServerName"'/'"$server_name"'/' '/etc/hosts'

  echo ""
  echo -e "${GREEN}### Création de l'utilisateur${NOCOLOR}"
    if [ ! -d /home/$login/ ]; then
          adduser $login
  	  else echo -e "L'utilisateur $login existe deja"
    fi
    usermod -a -G adm,sudo,www-data $login
fi

read -p "Voulez-vous lancer la mise-a-jour du systeme [O/n] ? " update_choice
if [[ "$update_choice" = 'O' ]]; then
  apt -y install sudo                          #
  sudo apt update -y
  sudo apt upgrade -y
fi
sleep 5

echo ""
echo -e "${GREEN}### Installation des paquets necessaires${NOCOLOR}"

sudo apt -y install unrar-free unzip zip hardinfo hwinfo htop sysv-rc-conf locate git curl iperf                 
sleep 5

echo ""
echo -e "${GREEN}################################################################"
echo "###           Pre-requis installes                          ###"
echo -e "################################################################${NOCOLOR}"
echo ""
sleep 5

echo ""
echo -e "${GREEN}### Configuration de GIT avec des couleurs${NOCOLOR}"
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
read -p "Utilisateur Git : " git_user
read -p "Email pour Git : " git_email
git config --global user.name $git_user
git config --global user.mail $git_email
cd /opt/
  if [ ! -d /opt/Git_Repos/cybit-script ]; then
    mkdir -p /opt/Git_Repos/
    git clone https://github.com/petitsurfeur/cybit-script.git
  else echo -e "Le dossier /opt/Git_Repos/cybit_script/ existe deja"
  fi

cd /opt/Git_Repos/cybit-script/update/ && ./install_update.sh

echo -e "${GREEN}### Installation et configuration des outils tiers${NOCOLOR}"

read -p "Voulez-vous installer Vim [O-n) ? " vim_choice
  if [[ "$vim_choice" = 'O' ]]; then
        cd /opt/Git_Repos/cybit-script/vim/ && ./install_vim.sh
          fi

read -p "Voulez-vous installer SSH [O-n) ? " ssh_choice
  if [[ "$ssh_choice" = 'O' ]]; then
        cd /opt/Git_Repos/cybit-script/ssh/ && ./install_ssh.sh
	  fi

read -p "Voulez-vous installer .bashrc [O-n) ? " bashrc_choice
  if [[ "$bashrc_choice" = 'O' ]]; then
        cd /opt/Git_Repos/cybit-script/bashrc && ./install_bashrc.sh
	  fi

read -p "Voulez-vous installer Exim4 [O-n) ? " exim4_choice
  if [[ "$exim4_choice" = 'O' ]]; then
        cd /opt/Git_Repos/cybit-script/exim4 && ./install_exim4.sh
	  fi

read -p "Voulez-vous installer Apticron [O-n) ? " apticron_choice
  if [[ "$apticron_choice" = 'O' ]]; then
        cd /opt/Git_Repos/cybit-script/apticron && ./install_apticron.sh
	  fi

read -p "Voulez-vous installer Fail2ban [O-n) ? " fail2ban_choice
  if [[ "$fail2ban_choice" = 'O' ]]; then
         cd /opt/Git_Repos/cybit-script/fail2ban && ./install_fail2ban.sh
           fi

read -p "Voulez-vous installer  UFW [O-n) ? " ufw_choice
  if [[ "$ufw_choice" = 'O' ]]; then
         cd /opt/Git_Repos/cybit-script/firewall && ./install_firewall.sh
           fi

read -p "Voulez-vous installer OpenVPN [O-n) ? " openvpn_choice
  if [[ "$openvpn_choice" = 'O' ]]; then
         cd /opt/Git_Repos/cybit-script/openvpn && ./install_openvpn_server.sh
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

