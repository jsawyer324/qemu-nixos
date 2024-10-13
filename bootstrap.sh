#! /usr/bin/env nix-shell

nix-shell -p git --run "git clone https://github.com/jsawyer324/qemu-nixos.git"

cd /home/nixos/qemu-nixos || exit

sudo sh ./setup.sh