# Development base configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  environment.systemPackages = with pkgs; [
    cachix
    direnv
    eza
    tmux
    gnumake
  ];
}
