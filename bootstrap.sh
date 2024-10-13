#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash git

echo "Cloning qemu-nixos2"
nix-shell -p git
git clone https://github.com/jsawyer324/qemu-nixos.git
cd qemu-nixos || exit
sudo sh ./setup.sh
