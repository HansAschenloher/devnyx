{ config, lib, pkgs, ... }:

{
  services = {
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
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
        touchpad.disableWhileTyping = true;
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

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  systemd.services.upower.enable = true;
}
