#!/bin/bash

#install vpn
WIRED="Wired connection 1"

PS3="Which vpn would you like to setup: "
select CITY in $(ls -d1 ./*/)
do
break
done

cd "$CITY" || exit

for i in *.ovpn; do nmcli connection import type openvpn file "$i"; done

for i in *.ovpn
do
  [[ -e "$i" ]] || break
  T=${i::-5}
  HOSTNAME=${i::-13}
  nmcli con mod "$T" ipv4.dns "103.86.96.100, 103.86.99.100"
  nmcli con mod "$T" ipv6.method "disabled"

done
cd ..

sudo nmcli con mod "${WIRED}" connection.autoconnect yes
sudo nmcli con mod "${WIRED}" ipv6.method "disabled"

sudo systemctl restart NetworkManager