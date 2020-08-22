#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

#set -e

echo ""
echo -e "${GREEN}### Securisation de Openssh-server${NOCOLOR}"
#apt update

sshd_conf=/etc/ssh/sshd_config.d/ubuntu.conf


# Check if root
if [[ "$EUID" -ne 0 ]];
then
    error "Desole, vous devez etre ROOT !"
  exit
fi


echo ""
read -p "Faut-il creer une paire de cle publique/privee de type ED25519 [O/n] ? " keyED25519_create
if [[ "$keyED25519_create" = 'O' ]]; then
  read -p "Quel est l'utilisateur ? " ssh_user
  read -p "Quel commentaire voulez-vous sur la cle (ex: ED25519-date) ? " keyED25519_comment
  ssh-keygen -o -a 100 -b 510 -t ed25519 -f /home/$ssh_user/.ssh/id_ed25519 -C "$keyED25519_comment"
  cat /home/$ssh_user/.ssh/id_ed25519.pub >> /home/$ssh_user/.ssh/authorized_keys
  chmod 0700 /home/$ssh_user/.ssh
  chmod 0600 /home/$ssh_user/.ssh/id_ed25519
  chmod 0644 /home/$ssh_user/.ssh/authorized_keys
fi 


echo ""
read -p "Voulez-vous configurer le serveur SSH [O/n] ? " ssh_configure_choice
if [[ "$ssh_configure_choice" = 'O'  ]]; then

  if [ ! -d /etc/ssh/sshd_config.d ]; then
    mkdir /etc/ssh/sshd_config.d/
    cp sshd_config /etc/ssh/ && cp ubuntu.conf /etc/ssh/sshd_config.d/
  else
    cp sshd_config /etc/ssh/ && cp ubuntu.conf /etc/ssh/sshd_config.d/
  fi

  read -p "Port a utiliser pour le serveur SSH (ex: 2022): " ssh_port
  read -p "Utilisateur a autoriser pour les connexions SSH: " ssh_user

  read -p "Voulez-vous ajouter votre cle privee dans le fichier /home/$ssh_user/.ssh/authorized_keys [O/n] ? " copy_priv_key_choice
  if [[ "$copy_priv_key_choice" = 'O' ]]; then
    read -p "Collez ici la cle privee: " private_key
    echo $private_key >> /home/$ssh_user/.ssh/authorized_keys
  fi

  echo ""
  echo -e "${GREEN}### Configuration du fichier /etc/ssh/sshd_config.d/ubuntu.conf${NOCOLOR}"
  sed -i -e 's/##PORT/'"$ssh_port"'/' $sshd_conf
  sed -i -e 's/##USER/'"$ssh_user"'/' $sshd_conf

  echo ""
  echo -e "${GREEN}--> Régénération de la clé ED25519 du serveur${NOCOLOR}"
    rm -f /etc/ssh/ssh_host_*
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

  echo -e "${GREEN}--> Retrait des moduli Diffie-Hellman faibles${NOCOLOR}"
    awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
    mv -f /etc/ssh/moduli.safe /etc/ssh/moduli

  echo -e "${GREEN}--> Restriction des ciphers, clés d’échange et des codes d’authentification${NOCOLOR}"
    echo -e "\nKexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com" >> $sshd_conf

fi


echo ""
echo -e "${GREEN}--> Redemarrage du service${NOCOLOR}"
#systemctl restart sshd.service

echo ""
echo -e "${RED}### Penser a modifier le port SSH $ssh_port et a charger la cle privee dans Putty${NOCOLOR}"
echo ""
