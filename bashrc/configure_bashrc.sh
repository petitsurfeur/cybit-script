cp bash_aliases /root/ /home/cybitnap/

cat << 'EOF' >> /root/.bashrc
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
