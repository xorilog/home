{ lib }:

with lib;

{
  # Fonctions utilitaires basiques
  # TODO: développer selon besoins

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
}