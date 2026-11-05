{ pkgs, nixosConfig, ... }:

{
  home.packages = with pkgs; [
    zoom-us
    signal-desktop
    slack
    discord
  ];
}
