{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pciutils
    file
    #gnumake
    #gcc
    #cudatoolkit
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  };

  nixpkgs.config.allowUnfree = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "21.05";
  hardware.opengl.driSupport32Bit = true;

}

