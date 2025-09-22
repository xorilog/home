{ lib, ... }:

with lib;

{
  # Fonction pour créer des imports conditionnels
  optionalImport = path: condition:
    if condition then [ path ] else [ ];

  # Fonction pour gérer les configurations par hostname
  hostConfig = hostname: path:
    (path + "/${hostname}");

  # Helper pour déterminer si desktop est activé
  hasDesktop = config:
    config.modules.desktop.enable or false;

  # Import conditionnel avancé avec vérification d'existence
  conditionalImport = basePath: name: condition:
    let
      fullPath = basePath + "/${name}";
    in
    optionals (condition && builtins.pathExists fullPath) [ fullPath ];

  # Génération d'imports par profils de machine  
  machineProfile = hostname:
    let
      profiles = {
        "nixophe" = [ "laptop" "development" "desktop" ];
        # Autres machines à venir
      };
    in
    profiles.${hostname} or [ "base" ];

  # Import intelligent par type de machine
  smartImports = hostname: basePath:
    let
      profiles = machineProfile hostname;
      profilePaths = map (profile: basePath + "/${profile}") profiles;
      existingPaths = filter builtins.pathExists profilePaths;
    in
    existingPaths;
}