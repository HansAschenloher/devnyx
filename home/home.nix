{ config, lib, pkgs, stdenv, ... }:

let
  hms = pkgs.callPackage ./switcher.nix { inherit config pkgs; };

  defaultPkgs = with pkgs; [
    # act                  # run github actions locally
    alacritty            # terminaljk
    any-nix-shell        # fish support for nix shell
    asciinema            # record the terminal
    audacious            # simple music player
    betterlockscreen     # fast lockscreen based on i3lock
    bottom               # alternative to htop & ytop
    brave		             # web browser
    cachix               # nix caching
    calibre              # e-book reader
    calc                 # random color support
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
    jetbrains.idea-ultimate #ItelliJ
    #k9s                  # k8s pods manager
    killall              # kill processes by name
    #libreoffice          # office suite
    libnotify            # notify-send command
    lazydocker		       # docker-compose viewer
    ncdu                 # disk space info (a better du)
    neofetch             # command-line system information
    nix-doc              # nix documentation search tool
    nix-tree             # to analyse nix dependencies
    manix                # documentation searcher for nix
    pavucontrol          # pulseaudio volume control
    paprefs              # pulseaudio preferences
    pasystray            # pulseaudio systray
    playerctl            # music player controller
    prettyping           # a nicer ping
    pulsemixer           # pulseaudio mixer
    pywal                # color shemes
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    shutter              # Screenshot utility
    signal-desktop       # signal messaging client
    simplescreenrecorder # self-explanatory
    spotify              # music source
    teamspeak_client     # TS3 Client
    tmux
    tldr                 # summary of a man page
    tor 		             # tor browser
    vlc                  # media player
    unzip
    xclip                # clipboard support (also for neovim)
    zathura		           # pdf viewer

    # fixes the `ar` error required by cabal
    binutils-unwrapped
  ];

  nvimPkgs = with pkgs; [
    rnix-lsp
    texlab

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
    ghcide
  ];

  goLangPkgs = with pkgs; [
    gocode-gomod
    go
  ];

  polybarPkgs = with pkgs; [
    #polybar
    font-awesome-ttf      # awesome fonts
    material-design-icons # fonts with glyphs
    networkmanager_dmenu  # netork modules
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


  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      nativeOnly = true;
    };
  };

  tiPkgs = with pkgs; [
    stack
    z3
    minisat
    picosat
  ];

  uniPkgs = tiPkgs;

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
    stateVersion  = "21.05";

    packages = defaultPkgs ++ gitPkgs ++ haskellPkgs ++ polybarPkgs ++ xmonadPkgs ++ nvimPkgs ++ uniPkgs;

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
    #iconTheme = {
      #name = "Adwaita-dark";
      #package = pkgs.gnome3.adwaita-icon-theme;
    #};
    #theme = {
      #name = "Adwaita-dark";
      #package = pkgs.gnome3.adwaita-icon-theme;
    #};
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
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    gpg.enable = true;

    htop.enable = true;
    htop.settings = {
      sortKey = "PERCENT_CPU";
    };

     jq.enable = true;
    ssh.enable = true;
  };

  services = {
    flameshot.enable = true;
  };
}
