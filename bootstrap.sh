#! /usr/bin/env nix-shell
#! nix-shell -p git

echo "Cloning qemu-nixos"
nix-shell -p git
git clone https://github.com/jsawyer324/qemu-nixos.git
cd qemu-nixos || exit
sudo sh ./setup.sh
