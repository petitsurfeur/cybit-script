cp .bash_aliases /root/ && cp .bash_aliases /home/cybitnap/

cat << 'EOF' >> /root/.bashrc
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
