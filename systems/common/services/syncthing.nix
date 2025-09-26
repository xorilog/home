# Syncthing configuration (pattern vdemeester)
{ config, lib, pkgs, globals, hostname, libx, ... }:
{
  services.syncthing = {
    enable = true;
    user = "xophe";
    dataDir = "/home/xophe/.syncthing";
    configDir = "/home/xophe/.syncthing";
    guiAddress = "127.0.0.1:8384";
    overrideFolders = false; # Just in case, will probably set to true later
    openDefaultPorts = true; # TODO: Xophe This has to be checked.
    settings = {
      devices = libx.generateSyncthingFolders hostname globals.machines."${hostname}" globals.machines globals.syncthingFolders;
    };
  };
}
