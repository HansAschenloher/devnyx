{config, pkgs, ... }:

let
  browser = "${pkgs.brave}/bin/brave";

  mainBar = pkgs.callPackage ./bar.nix {};
  openCalendar = "${pkgs.gnome3.gnome-calendar}/bin/gnome-calendar";
  #openCalendar = "null";

  xdgUtils = pkgs.xdg_utils.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
      postInstall = old.postInstall + "\n" + ''
        wrapProgram $out/bin/xdg-open --suffix PATH : /run/current-system/sw/bin --suffix BROWSER : ${browser}
      '';
    }
  );

  openGithub = "${xdgUtils}/bin/xdg-open https\\://github.com/notifications";

  mypolybar = pkgs.polybar.override {
    alsaSupport   = true;
    githubSupport = true;
    mpdSupport    = true;
    pulseSupport  = true;
  };

  # theme adapted from: https://github.com/adi1090x/polybar-themes#-polybar-5
  bars   = builtins.readFile ./bars.ini;
  colors = builtins.readFile ./colors.ini;
  mods1  = builtins.readFile ./modules.ini;
  mods2  = builtins.readFile ./user_modules.ini;

  monitorScript   = pkgs.callPackage ./scripts/monitor.nix {};
  mprisScript     = pkgs.callPackage ./scripts/mpris.nix {};
  networkScript   = pkgs.callPackage ./scripts/network.nix {};

  cal = ''
    [module/clickable-date]
    inherit = module/date
    label = %{A1:${openCalendar}:}%time%%{A}
  '';

  github = ''
    [module/clickable-github]
    inherit = module/github
    token = ''${file:${config.xdg.configHome}/polybar/github-notifications-token}
    label = %{A1:${openGithub}:}  %notifications%%{A}
  '';

  mpris = ''
    [module/mpris]
    type = custom/script

    exec = ${mprisScript}/bin/mpris
    tail = true

    label-maxlen = 60

    interval = 2
    format =   <label>
    format-padding = 2
  '';

  xmonad = ''
    [module/xmonad]
    type = custom/script
    exec = ${pkgs.xmonad-log}/bin/xmonad-log

    tail = true
  '';

  customMods = mainBar + cal + github + mpris + xmonad;
in
{
  #xdg.configFile."polybar/github-notifications-token".source = ../../secrets/github-notifications-token;

  services.polybar = {
    enable = true;
    package = mypolybar;
    config = ./config.ini;
    extraConfig = bars + colors + mods1 + mods2 + customMods;
    script = ''
      export MONITOR=$(${monitorScript}/bin/monitor)
      echo "Running polybar on $MONITOR"
      export ETH_INTERFACE=$(${networkScript}/bin/check-network eth)
      export WIFI_INTERFACE=$(${networkScript}/bin/check-network wifi)
      echo "Network interfaces $ETH_INTERFACE & $WIFI_INTERFACE"
      polybar top 2>${config.xdg.configHome}/polybar/logs/top.log & disown
      polybar bottom 2>${config.xdg.configHome}/polybar/logs/bottom.log & disown
    '';
  };
}
