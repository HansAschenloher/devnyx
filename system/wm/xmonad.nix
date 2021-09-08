{ config, lib, pkgs, ... }:

{
  services = {
    upower.enable = true;

    dbus = {
      enable = true;
    };

    xserver = {
      enable = true;

      extraLayouts.de-custom = {
        description = "DE layout with Esc on CAPS_LOCK";
        languages   = [ "de" ];
        symbolsFile = ./de-custom.xkb;
      };

      layout = "de-custom";

      libinput = {
        enable = true;
        touchpad.disableWhileTyping = false;
      };

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      displayManager = {
        defaultSession = "none+xmonad";
	lightdm.enable = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      xkbOptions = "caps:ctrl_modifier";
    };
  };

  hardware.bluetooth.enable = false;
  services.blueman.enable = false;

  systemd.services.upower.enable = true;
}
