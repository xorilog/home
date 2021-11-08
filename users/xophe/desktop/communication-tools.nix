{ pkgs, nixosConfig, ... }:

{
  home.sessionVariables = { WEBKIT_DISABLE_COMPOSITING_MODE = 1; };
  home.packages = with pkgs; [
    zoom-us
    signal-desktop
    slack
    discord
    teams
  ];
}
