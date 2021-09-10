#! /usr/bin/env bash

# Shows the output of every command
set +x

# Pin Nixpkgs to NixOS unstable on January 31st of 2021
export PINNED_NIX_PKGS="https://github.com/NixOS/nixpkgs/archive/891f607d530.tar.gz"
# Switch to the unstable channel
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos

rm -rf ~/.xmonad/*
rm -rf ~/.config/*

# Nix configuration
sudo cp system/configuration.nix /etc/nixos/
sudo cp -r system/wm/ /etc/nixos/
sudo cp -r system/nvidia/ /etc/nixos/
sudo nixos-rebuild -I nixpkgs=$PINNED_NIX_PKGS switch --upgrade

# Manual steps
mkdir -p $HOME/.config/polybar/logs
touch $HOME/.config/polybar/logs/bottom.log
touch $HOME/.config/polybar/logs/top.log
mkdir -p $HOME/.cache/fzf-hoogle
touch $HOME/.cache/fzf-hoogle/cache.json

# Home manager
mkdir -p $HOME/.config/nixpkgs/
cp -r home/* $HOME/.config/nixpkgs/
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
#cp home/nixos.png $HOME/Pictures/
home-manager switch

# Set screenlock wallpaper
betterlockscreen -u home/nixos.png
