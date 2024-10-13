#! /usr/bin/env nix-shell
#! nix-shell -p bash git
#! nix-shell -i bash
#! nix-shell --command "git clone https://github.com/jsawyer324/qemu-nixos.git" 

echo "Cloning qemu-nixos5"
#git clone https://github.com/jsawyer324/qemu-nixos.git
cd /home/nixos/qemu-nixos || exit
sudo sh ./setup.sh
