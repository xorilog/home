# Direnv configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  environment = {
    # Path to link from packages to /run/current-system/sw
    pathsToLink = [
      "/share/nix-direnv"
    ];
    systemPackages = [ pkgs.direnv ];
  };
}
