#! /usr/bin/env nix-shell

# to run, load up the iso and run the following command
# sh <(curl -sL bit.ly/j324nix)


nix-shell -p git --run "git clone https://github.com/jsawyer324/qemu-nixos.git"

cd /home/nixos/qemu-nixos || exit

sudo sh ./setup.sh