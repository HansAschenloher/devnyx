{ config, pkgs, ...}:

let
  fish   = "${pkgs.fish}/bin/fish";
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
in
  pkgs.writeShellScriptBin "hms" ''
    home-manager -f ${config.xdg.configHome}/nixpkgs/display/pc.nix switch

    if [[ $1 == "fish" ]]; then
      ${fish} -c fish_update_completions
    fi
  ''
