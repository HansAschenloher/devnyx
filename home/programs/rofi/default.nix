{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.termite}/bin/termite";
    theme = ./theme.rafi;
  };
}
