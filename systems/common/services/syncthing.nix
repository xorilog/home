# Syncthing configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    user = "xophe";
    dataDir = "/home/xophe/.syncthing";
    configDir = "/home/xophe/.syncthing";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
  };
}
