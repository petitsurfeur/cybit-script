# Modification du fichier proxmoxlib.js
sed -Ezi.bak "s/if \(res === null \|\| res === undefined \|\| \!res \|\| res/if (true) { orig_cmd(); } else if (res/gi" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
# Redémarrage du service de l'interface web
systemctl restart pveproxy.service
