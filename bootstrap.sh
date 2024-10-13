#! /usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash git
#! nix-shell --run "git clone https://github.com/jsawyer324/qemu-nixos.git" 

echo "Cloning qemu-nixos4"
#git clone https://github.com/jsawyer324/qemu-nixos.git
cd /home/nixos/qemu-nixos || exit
sudo sh ./setup.sh
