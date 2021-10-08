{ pkgs, ...}:

let
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
in
  pkgs.writeShellScriptBin "monitor" ''
    monitors=$(${xrandr} --listmonitors)

    if [[ $monitors == *"HDMI-0"* ]]; then
      echo "HDMI-0"
    elif [[ $monitors == *"DP-0"* ]]; then
      echo "DP-0"
    elif [[ $monitors == *"eDP-1" ]]; then
      echo "eDP-1"
    else
      echo "DP-0"
    fi
  ''
