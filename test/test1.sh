echo ""
echo -e "${GREEN}### Installation des paquets utiles${NOCOLOR}"
  packages = unrar-free unzip hardinfo hwinfo htop sysv-rc-conf locate git curl
    echo -e "Les paquets utiles sont : " $packages
      read -p "Voulez-vous installer les paquets utiles [O/n] ? " packages_choice
          if [[ "$packages_choice" = 'O' ]]; then
	          sudo apt install -y $packages
		  sleep 2

