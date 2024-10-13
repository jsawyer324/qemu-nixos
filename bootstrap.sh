#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash git

echo "Cloning qemu-nixos3"
git clone https://github.com/jsawyer324/qemu-nixos.git
cd qemu-nixos || exit
sudo sh ./setup.sh
