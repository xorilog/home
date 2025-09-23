# Configuration Syncthing conditionnelle
# Chargée uniquement si la machine a des dossiers syncthing configurés
{ config, lib, pkgs, globals, hostname, libx, ... }:
{
  services.syncthing = {
    enable = true;
    
    # Configuration basée sur les globals de la machine
    extraOptions = [
      "--gui-address=0.0.0.0:8384"
    ];
  };

  # TODO: Intégrer les fonctions avancées de vdemeester
  # - generateSyncthingFolders
  # - generateSyncthingDevices  
  # - syncthingGuiAddress
  
  # Pour le moment, configuration basique qui sera étendue
  # quand on implémentera la structure complète des globals
}