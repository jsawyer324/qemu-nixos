#!/bin/bash

#partition disk
sudo sgdisk -n 1::+512M /dev/vda -t 1:ef00
sudo sgdisk -n 2::+2G /dev/vda -t 2:8200
sudo sgdisk -n 3:: /dev/vda 

#format and mount
sudo mkfs.fat -F 32 /dev/vda1
sudo fatlabel /dev/vda1 NIXBOOT
sudo mkfs.ext4 /dev/vda3 -L NIXROOT
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot

#activate swap
sudo mkswap /dev/vda2
sudo swapon /dev/vda2

#config
sudo nixos-generate-config --root /mnt

#copy
sudo cp ./configuration.nix /mnt/etc/nixos/
sudo cp ./us5068.nordvpn.com.udp1194.ovpn /mnt/etc/nixos/

#update hostname
read -rp "Enter hostname: " HOSTNAME
sed -i "s/nixoshost/$HOSTNAME/g" /mnt/etc/locale.gen

#install
cd /mnt || exit
sudo nixos-install

reboot now