#!/bin/bash
 
# First argument: Client identifier
 
KEY_DIR=/etc/openvpn/easy-rsa/keys
OUTPUT_DIR=/etc/openvpn/client-configs/files
BASE_CONFIG=/etc/openvpn/client-configs/base.conf

cat ${BASE_CONFIG} \
      <(echo -e '<ca>') \
      <(echo -e '\n') ${KEY_DIR}/ca.crt \
      <(echo -e '</ca>') \
      <(echo -e '<cert>') \
      <(echo -e '\n') ${KEY_DIR}/${1}.crt \
      <(echo -e '</cert>') \
      <(echo -e '<key>') \
      <(echo -e '\n') ${KEY_DIR}/${1}.key \
      <(echo -e '</key>') \
      <(echo -e '<tls-auth>') \
      <(echo -e '\n') ${KEY_DIR}/ta.key \
      <(echo -e '</tls-auth>') \
      <(echo -e '') > ${OUTPUT_DIR}/${1}.ovpn 
