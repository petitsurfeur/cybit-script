#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

#set -e

echo ""
echo -e "${GREEN}### Installation de Openssh-server${NOCOLOR}"
#apt update

sshd_conf=/etc/ssh/sshd_config

read -p "Port a utiliser pour le serveur SSH (ex: 2022): " ssh_port
read -p "Utilisateur a autoriser pour les connexions SSH (ex: $user_add :) " ssh_user

apt install -y openssh-server

if [ ! -f /etc/ssh/sshd_config.SAVE ]; then
 cp /etc/ssh/sshd_config /etc/ssh/sshd_config.SAVE
fi

echo ""
read -p "Voulez-vous configurer le serveur SSH [O/n] ?" ssh_configure
if [[ "$ssh_configure" = 'O'  ]]; then

  echo ""
  echo -e "${GREEN}### Configuration du fichier /etc/ssh/sshd_config${NOCOLOR}"
  sed -i -e 's/^#*Port.*/Port '"$ssh_port"'/' $sshd_conf
  sed -i '/Port '"$ssh_port"'/a\Protocol 2' $sshd_conf
  sed -i -e 's/^#*SyslogFacility AUTH/SyslogFacility AUTH/' $sshd_conf
  sed -i -e 's/^#*LogLevel INFO/LogLevel INFO/' $sshd_conf
  sed -i -e 's/^#*LoginGraceTime.*/LoginGraceTime 30/' $sshd_conf
  sed -i -e 's/^#*PermitRootLogin.*/PermitRootLogin no/' $sshd_conf
  sed -i '/PermitRootLogin no/a\AllowUsers '"$ssh_user"'' $sshd_conf
  sed -i -e 's/^#*StrictModes yes/StrictModes yes/' $sshd_conf
  sed -i -e 's/^#*#X11DisplayOffset 10/X11DisplayOffset 10/' $sshd_conf
  sed -i -e 's/^#*PrintLastLog yes/PrintLastLog yes/' $sshd_conf
  sed -i -e 's/^#*TCPKeepAlive yes/TCPKeepAlive yes/' $sshd_conf
  sed -i -e 's/^#*UseDNS no/UseDNS no/' $sshd_conf
  sed -i -e 's/^#*MaxStartups.*$/MaxStartups 3:50:10/g' $sshd_conf
fi

echo ""
read -p "Voulez-vous securiser la connexion par cle [O/n] ? " secured_ssh
  if [[ "$secured_ssh" = 'O' ]] && [ ! -d /home/$ssh_user/.ssh/ ]; then
    echo -e "${RED}### Vous devez lancer ssh-keygen -t rsa -b 2048 avec l'utilisateur $ssh_user puis creer le fichier authorized_files avant de relancer ce script"

    elif [ -f /home/$ssh_user/.ssh/authorized_keys ]; then
      chmod 400 /home/$ssh_user/.ssh/id*
      sed -i -e 's/^#*PubkeyAuthentication yes/PubkeyAuthentication yes/' $sshd_conf
      sed -i -e 's/^#*HostbasedAuthentication no/HostbasedAuthentication no/' $sshd_conf
      sed -i -e 's/^#*IgnoreRhosts yes/IgnoreRhosts yes/' $sshd_conf
      sed -i -e 's/^#*PasswordAuthentication yes/PasswordAuthentication no/' $sshd_conf
      sed -i -e 's/^#*PermitEmptyPasswords no/PermitEmptyPasswords no/' $sshd_conf
    
    else
    echo -e "${RED}### le fichier authorized_files n'existe pas pour l'utilisateur $ssh_user"
    fi  

echo ""
echo -e "${GREEN}--> Redemarrage du service${NOCOLOR}"
systemctl restart sshd.service

echo ""
echo -e "${RED}### Penser a modifier le port SSH $ssh_port dans Putty${NOCOLOR}"
echo ""
