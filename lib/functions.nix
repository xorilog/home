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
}