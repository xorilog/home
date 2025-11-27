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
let
  hostModule = ./. + "/${hostname}/default.nix";
  hostExtra = ./. + "/${hostname}/extra.nix";
in
{
  imports =
    lib.optional (builtins.pathExists hostModule) hostModule
    ++ lib.optional (builtins.pathExists hostExtra) hostExtra;

  # Configuration nixpkgs avec overlays (commune Linux/Darwin)
  nixpkgs = {
    overlays = [
      # Nos overlays (système avancé)
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # Overlays externes
      inputs.ghostty.overlays.default or (_: _: { })
      inputs.claude-desktop.overlays.default or (_: _: { })

      # Packages spéciaux depuis inputs
      (_: prev: {
        inherit (inputs.ghostty.packages.${prev.system}) ghostty;
        inherit (inputs.claude-desktop.packages.${prev.system}) claude-desktop-with-fhs;
      })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Configuration Nix avec flakes (compatibles nix-darwin)
  nix = {
    # Registres flake pour cohérence nix3 commands
    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);

    # Legacy channels pour compatibilité
    nixPath = lib.mkForce (
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry
    );

    # Optimisation automatique (nix-darwin)
    optimise.automatic = true;

    settings = {
      # Fonctionnalités expérimentales
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      sandbox = true;

      # Utilisateurs de confiance
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [ "@wheel" ];

      # XDG pour organisation
      use-xdg-base-directories = true;

      # Add some "caches" (substituters)
      substituters = [
        "https://cache.nixos.org/"
        "https://r-ryantm.cachix.org"
        "https://shortbrain.cachix.org"
        "https://vdemeester.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
      ];
      trusted-public-keys = [
        "r-ryantm.cachix.org-1:gkUbLkouDAyvBdpBX0JOdIiD2/DP1ldF3Z3Y6Gqcc4c="
        "shortbrain.cachix.org-1:dqXcXzM0yXs3eo9ChmMfmob93eemwNyhTx7wCR4IjeQ="
        "mic92.cachix.org-1:gi8IhgiT3CYZnJsaW7fxznzTkMUOn1RY4GmXdT/nXYQ="
        "vdemeester.cachix.org-1:eZWNOrLR9A9szeMahn9ENaoT9DB3WgOos8va+d2CU44="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
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
  };

  # Version système (nix-darwin attend un entier entre 1 et 6)
  system.stateVersion = lib.mkDefault 6;
}
