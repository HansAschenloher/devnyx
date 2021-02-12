{ config, lib, pkgs, stdenv, ... }:

let
  hms = pkgs.callPackage ./switcher.nix { inherit config pkgs; };

  defaultPkgs = with pkgs; [
    act                  # run github actions locally
    any-nix-shell        # fish support for nix shell
    asciinema            # record the terminal
    audacious            # simple music player
    betterlockscreen     # fast lockscreen based on i3lock
    bottom               # alternative to htop & ytop
    brave		 # web browser 
    cachix               # nix caching
    calibre              # e-book reader
    dmenu                # application launcher
    docker-compose       # docker manager
    dive                 # explore docker layers
    exa                  # a better `ls`
    fd                   # "find" for files
    gimp                 # gnu image manipulation program
    gnumake
    hms                  # custom home-manager switcher
    hyperfine            # command-line benchmarking tool
    insomnia             # rest client with graphql support
    #k9s                  # k8s pods manager
    killall              # kill processes by name
    #libreoffice          # office suite
    libnotify            # notify-send command
    lazydocker		 # docker-compose viewer
    ncdu                 # disk space info (a better du)
    neofetch             # command-line system information
    nix-doc              # nix documentation search tool
    manix                # documentation searcher for nix
    pavucontrol          # pulseaudio volume control
    paprefs              # pulseaudio preferences
    pasystray            # pulseaudio systray
    playerctl            # music player controller
    prettyping           # a nicer ping
    pulsemixer           # pulseaudio mixer
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    signal-desktop       # signal messaging client
    simplescreenrecorder # self-explanatory
    spotify              # music source
    tldr                 # summary of a man page
    tor 		 # tor browser
    vlc                  # media player
    xclip                # clipboard support (also for neovim)
    zathura		 # pdf viewer

    # fixes the `ar` error required by cabal
    binutils-unwrapped
  ];


  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
    git-extras    # git utils
  ];

  haskellPkgs = with pkgs.haskellPackages; [
    brittany                # code formatter
    cabal2nix               # convert cabal projects to nix
    cabal-install           # package manager
    ghc                     # compiler
    haskell-language-server # haskell IDE (ships with ghcide)
    hoogle                  # documentation
    nix-tree                # visualize nix dependencies
  ];

  polybarPkgs = with pkgs; [
    font-awesome-ttf      # awesome fonts
    material-design-icons # fonts with glyphs
  ];

  xmonadPkgs = with pkgs; [
    haskellPackages.libmpd # music player daemon
    haskellPackages.xmobar # status bar
    networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet   # networkmanager applet
    nitrogen               # wallpaper manager
    xcape                  # keymaps modifier
    xorg.xkbcomp           # keymaps modifier
    xorg.xmodmap           # keymaps modifier
    xorg.xrandr            # display manager (X Resize and Rotate protocol)
  ];

in
{
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = p: {
      # temporary hack for fish until there's a fix upstream
      fish-foreign-env = pkgs.fishPlugins.foreign-env;
      nur = import (import pkgs/nur.nix) { inherit pkgs; };
    };
  };

  nixpkgs.overlays = [];

  imports = (import ./programs) ++ (import ./services);

  xdg.enable = true;

  home = {
    username      = "hans";
    homeDirectory = "/home/hans";
    stateVersion  = "20.09";

    packages = defaultPkgs ++ gitPkgs ++ haskellPkgs ++ polybarPkgs ++ xmonadPkgs;

    sessionVariables = {
      DISPLAY = ":0";
      EDITOR = "nvim";
    };
  };

  manual = {
    json.enable = false;
    html.enable = false;
    manpages.enable = false;
  };

  # notifications about home-manager news
  news.display = "silent";

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
  };

  programs = {
    bat.enable = true;

    broot = {
      enable = true;
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      enableNixDirenvIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    gpg.enable = true;

    htop = {
      enable = true;
      sortDescending = true;
      sortKey = "PERCENT_CPU";
    };

     jq.enable = true;
    ssh.enable = true;
  };

  services = {
    flameshot.enable = true;
  };

}
