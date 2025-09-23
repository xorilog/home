{
  config,
  desktop,
  hostname,
  inputs,
  lib,
  outputs,
  stateVersion,
  globals,
  ...
}:
{
  # Imports conditionnels basés sur hostname et desktop (pattern vdemeester)
  imports = [
    # Configuration spécifique machine (hardware, boot, etc.)
    (./. + "/hosts/${hostname}.nix")
    
    # Modules système communs
    ./common
  ]
  # Import conditionnel desktop si défini
  ++ lib.optional (builtins.isString desktop) ./common/desktop
  # Import conditionnel fichier extra par hostname
  ++ lib.optional (builtins.pathExists (./. + "/hosts/${hostname}/extra.nix")) ./hosts/${hostname}/extra.nix;

  # Configuration nixpkgs avec overlays
  nixpkgs = {
    overlays = [
      # Nos overlays locaux (TODO: développer)
      # outputs.overlays.additions
      # outputs.overlays.modifications
      
      # Overlays externes
      inputs.emacs-overlay.overlays.default
      # inputs.sops-nix.overlays.default (pas d'overlay sops)
      
      # Compatibility layer (migration sources.nix)
      (_: prev: {
        # TODO: migrer packages depuis default.nix
      })
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Configuration Nix avec flakes (pattern vdemeester)
  nix = {
    # Registres flake pour cohérence nix3 commands
    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);

    # Legacy channels pour compatibilité
    nixPath = lib.mkForce (
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry
    );

    # Optimisation automatique
    optimise = {
      automatic = true;
      dates = [ "03:10" ]; # 3h du matin
    };

    settings = {
      # Fonctionnalités expérimentales
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      
      # Optimisation store
      auto-optimise-store = true;
      
      # Utilisateurs de confiance
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "@wheel" ];
      
      # XDG pour organisation
      use-xdg-base-directories = true;
      
      # Caches binaires
      substituters = [
        "https://cache.nixos.org/"
        # TODO: ajouter autres caches si nécessaire
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    # Options supplémentaires
    extraOptions = ''
      connect-timeout = 20
      build-cores = 0
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
    '';

    # Performance sur laptops
    daemonIOSchedClass = "idle";
    daemonCPUSchedPolicy = "idle";
  };

  # Fix stack limit pour nix-daemon
  systemd.services.nix-daemon.serviceConfig."LimitSTACK" = "infinity";

  # Version système (mkDefault pour éviter conflit avec modules existants)
  system = {
    stateVersion = lib.mkDefault stateVersion;
  };
}