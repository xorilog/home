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
    # Configuration spécifique machine (pattern vdemeester)
    ./nixophe/boot.nix
    ./nixophe/hardware.nix
    ./nixophe/extra.nix
    
    # Modules système communs
    ./common/base
    ./common/users
    ./common/hardware
  ]
  # Import conditionnel desktop si défini
  ++ lib.optional (builtins.isString desktop) ./common/desktop;

  # Configuration nixpkgs avec overlays (pattern vdemeester)
  nixpkgs = {
    overlays = [
      # Nos overlays (système avancé)
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      
      # Overlays externes
      inputs.ghostty.overlays.default or (_: _: {})
      inputs.claude-desktop.overlays.default or (_: _: {})
      
      # Packages spéciaux depuis inputs
      (_: prev: {
        inherit (inputs.ghostty.packages.${prev.system}) ghostty;
        inherit (inputs.claude-desktop.packages.${prev.system}) claude-desktop-with-fhs;
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
