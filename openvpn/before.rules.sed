# Allow traffic from OpenVPN client to vmbr0 (change to the interface you discovered!)
-A POSTROUTING -s 10.8.0.0/8 -o ens18 -j MASQUERADE

