# Configuration Syncthing conditionnelle
# Chargée uniquement si la machine a des dossiers syncthing configurés
{
  config,
  lib,
  pkgs,
  globals,
  hostname,
  libx,
  ...
}:
{
  warnings = [ "Home syncthing for ${hostname}" ];
  services.syncthing = {
    enable = true;
    overrideFolders = false;
    # If we want to allow this from somewhere else on macOS, we need to swap this and disable the Apple Firewall (WTF)
    # guiAddress = if pkgs.stdenv.hostPlatform.isDarwin then "0.0.0.0:8384" else libx.syncthingGuiAddress globals.machines."${hostname}";
    guiAddress = libx.syncthingGuiAddress globals.machines."${hostname}";
    settings = {
      devices =
        libx.generateSyncthingFolders hostname globals.machines."${hostname}" globals.machines
          globals.syncthingFolders;
    };
  };

  # TODO: Intégrer les fonctions avancées de vdemeester
  # - generateSyncthingFolders
  # - generateSyncthingDevices
  # - syncthingGuiAddress
}
