#format disks
sudo sgdisk -n 1::+512M /dev/vda -t 1:ef00
sudo sgdisk -n 2:: /dev/vda 

#mount
sudo mkfs.fat -F 32 /dev/vda1
sudo fatlabel /dev/vda1 NIXBOOT
sudo mkfs.ext4 /dev/vda2 -L NIXROOT
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot

#copy
sudo cp ./configuration.nix /mnt/etc/nixos/

#config
sudo nixos-generate-config --root /mnt

#install
cd /mnt
sudo nixos-install
