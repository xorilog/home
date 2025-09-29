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

    # Configuration basée sur les globals de la machine
    extraOptions = [
      "--no-default-folder"
    ];
    overrideFolders = false;
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
