{ lib, hostname ? "", ... }:

{
  # Configuration globale du projet
  # Inspiré du pattern vdemeester
  
  # Informations machines
  machines = {
    nixophe = {
      system = "x86_64-linux";
      desktop = "i3"; # ou "sway", null pour headless
      hardware = "laptop";
      location = "home";
    };
  };
  
  # Configuration SSH (TODO: à compléter)
  ssh = {
    xophe = [
      # "ssh-rsa AAAA..." # TODO: ajouter clés SSH
    ];
  };
  
  # Utilisateurs système
  users = {
    xophe = {
      uid = 1000;
      description = "Christophe Boucharlat";
      shell = "zsh";
    };
  };
  
  # Configuration réseau (TODO: secrets)
  network = {
    # TODO: déplacer vers secrets ou agenix
    domain = "local";
  };
  
  # Versions par défaut
  versions = {
    stateVersion = "24.11";
    nixpkgs = "nixos-unstable";
  };
}