{ lib }:

with lib;

{
  # Fonctions utilitaires basiques et pattern vdemeester
  
  # Vérifier si un chemin existe  
  pathExists = path: builtins.pathExists path;
  
  # Fonction pour importer conditionnellement
  optionalImport = path: default: 
    if pathExists path then import path else default;
    
  # Fonction pour créer des imports conditionnels par hostname  
  hostImport = hostname: path:
    let fullPath = path + "/${hostname}.nix"; 
    in optional (pathExists fullPath) fullPath;
    
  # Fonction pour créer des imports conditionnels par desktop
  desktopImport = desktop: path:
    if desktop != null 
    then optional (pathExists (path + "/${desktop}.nix")) (path + "/${desktop}.nix")
    else [];

  # === FONCTIONS VDEMEESTER PATTERN ===
  
  # Vérifier si hostname correspond au nom donné
  isCurrentHost = hostname: n: n == hostname;
  
  # Vérifier si une machine a des dossiers syncthing configurés
  hasSyncthingFolders = host:
    builtins.hasAttr "syncthing" host
    && builtins.hasAttr "folders" host.syncthing
    && (builtins.length (lib.attrsets.attrValues host.syncthing.folders)) > 0;
  
  # Vérifier si une machine a une clé publique VPN
  hasVPNPublicKey = host: 
    (lib.attrsets.attrByPath [ "net" "vpn" "pubkey" ] "" host) != "";
    
  # Vérifier si une machine a des IPs VPN
  hasVPNips = host: 
    (builtins.length (lib.attrsets.attrByPath [ "net" "vpn" "ips" ] [ ] host)) > 0;
    
  # Vérifier si une machine a des clés SSH configurées
  hasSSHHostKeys = host: 
    builtins.hasAttr "ssh" host && builtins.hasAttr "hostKey" host.ssh;
}