#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

#set -e

echo ""
echo -e "${GREEN}### Installation de Openssh-server${NOCOLOR}"

sshd_conf=/etc/ssh/sshd_config
ubuntu_conf=/etc/ssh/sshd_config.d/ubuntu.conf

apt install -y openssh-server

if [ ! -f /etc/ssh/sshd_config.ORIGINAL ]; then
 cp /etc/ssh/sshd_config /etc/ssh/sshd_config.ORIGINAL
fi

echo ""
read -p "Port a utiliser pour le serveur SSH (ex: 2022): " ssh_port
read -p "Utilisateur a autoriser pour les connexions SSH (ex: $user_add :) " ssh_user

echo ""
read -p "Voulez-vous configurer le serveur SSH [O/n] ? " ssh_configure
if [[ "$ssh_configure" = 'O'  ]]; then

  if [ ! -d /etc/ssh/sshd_config.d]; then
    mkdir /etc/ssh/sshd_coonfig.d
    cp ubuntu.conf /etc/ssh/sshd_config.d/
    sed -i '/^Include /etc/ssh/sshd_config.d/d' /etc/ssh/sshd_config

    cat << 'EOF' >> /etc/ssh/sshd_config
    Include /etc/ssh/sshd_config.d/*.conf
EOF
  fi

  cp ubuntu.conf /etc/ssh/sshd_config.d/
  echo ""

  echo -e "${GREEN}### Configuration des fichiers /etc/ssh/sshd_config et ubuntu.conf${NOCOLOR}"
  sed -i 's/^UsePAM/#UsePAM/' $sshd_conf
  sed -i 's/^X11Forwarding/#UseForwarding/' $sshd_conf
  sed -i 's/^PrintMotd/#PrintMotd/' $sshd_conf
  sed -i 's/^PasswordAuthentication/#PasswordAuthentication/' $sshd_conf

  sed -i 's/^Port/Port '"$ssh_port"'/' $ubuntu_conf
  sed -i 's/^AllowUsers/AllowUsers '"$ssh_user"'/' $ubuntu_conf
fi

echo ""
read -p "Voulez-vous regenerer les cles [O/n] ? " regenerate_keys
if [[ "$regenerate_keys" = 'O' ]]; then
  ActualServerName=$(hostname -s)


  ### Regenerer cles serveur
  rm /etc/ssh/ssh_host_*
  ssh-keygen -q -N "" -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
  ssh-keygen -q -N "" -t ed25519 -b 521 -f /etc/ssh/ssh_host_ed25519_key

  ### Generer cles client
  if [ -d /home/$ssh_user/.ssh/ ]; then
    rm /home/$ssh_user/.ssh/*
  else
    mkdir /home/$ssh_user/.ssh
  fi
  ssh-keygen -o -a 100 -b 521 -t ed25519 -f /home/$ssh_user/.ssh/id_ed25519 -C "ed25519-key_$ActualServerName_$(date +%Y-%m-%d)"
  chown $ssh_user:$ssh_user /home/$ssh_user/.ssh/*
fi


echo ""
read -p "Voulez-vous securiser la connexion par cle (EXPERIMENTAL) [O/n] ? " secure_ssh
if [[ "$secure_ssh" = 'O' ]]; then

  if [ ! -f /home/$ssh_user/.ssh/authorized_keys ]; then
    touch /home/$ssh_user/.ssh/authorized_keys
    chown $ssh_user:$ssh_user /home/$ssh_user/.ssh/*
    echo -e "${RED}### Vous devez ajouter votre cle publique dans le fichier authorized_keys ${NOCOLOR}"

    read -p "Collez votre cle publique SSH : " public_ssh_key
    echo $public_ssh_key >> /home/$ssh_user/.ssh/authorized_keys

  fi

  sed -i 's/#AuthenticationMethods publickey/AuthenticationMethods publickey/' $ubuntu_conf
  sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' $ubuntu_conf
  sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' $ubuntu_conf
  sed -i 's/UsePAM yes/UsePAM no/' $ubuntu_conf

  ### Securisation du fichier moduli et restriction des ciphers, cles d'echange et codes d'authentification
  if [ ! -f /etc/ssh/moduli.ORIGINAL ]; then
    cp /etc/ssh/moduli /etc/ssh/moduli.ORIGINAL
  fi
  sudo awk '$5 >= 3071' /etc/ssh/moduli
  echo -e "\nKexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com" >> /etc/ssh/sshd_config.d/ubuntu.conf

fi

echo ""
echo -e "${GREEN}--> Redemarrage du service${NOCOLOR}"
systemctl restart sshd.service

echo ""
echo -e "${RED}### Le Service a ete redemarre !! NE QUITTEZ PAS LA SESSION SSH ACTUELLE !!! Lancez une connexion SSH apres avoir modifier le port SSH $ssh_port dans Putty${NOCOLOR}"
echo ""
