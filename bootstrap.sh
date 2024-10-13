#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash git


git clone https://github.com/jsawyer324/qemu-nixos.git
cd qemu-nixos || exit
sudo sh ./setup.sh
