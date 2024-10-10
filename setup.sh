#format disks
sudo sgdisk -n 1::+512M /dev/vda -t 1:ef00
sudo sgdisk -n 2::+2G /dev/vda -t 2:8200
sudo sgdisk -n 3:: /dev/vda 

sleep 10

#mount
sudo mkfs.fat -F 32 /dev/vda1
sudo fatlabel /dev/vda1 NIXBOOT
sudo mkfs.ext4 /dev/vda2 -L NIXROOT
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot

sleep 10

#swap
#sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152
#sudo chmod 600 /mnt/.swapfile
#sudo mkswap /mnt/.swapfile
#sudo swapon /mnt/.swapfile
sudo mkswap /dev/vda2
sudo swapon /dev/vda2

sleep 10

#config
sudo nixos-generate-config --root /mnt

sleep 10

#copy
sudo cp ./configuration.nix /mnt/etc/nixos/
sudo cp ./us5068.nordvpn.com.udp1194.ovpn /mnt/etc/nixos/

#sleep 10


#install
cd /mnt
sudo nixos-install
