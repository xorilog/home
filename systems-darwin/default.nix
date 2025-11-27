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
  # Disable nix-darwin's Nix management when using Determinate Systems
  # With nix.enable = false, nix-darwin won't manage the Nix daemon.
  # Nix settings should be configured via Determinate Systems or /etc/nix/nix.conf
  nix = {
    enable = false;

    # Registry can still be set for user-level flake registry
    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);

    # Legacy channels pour compatibilité
    nixPath = lib.mkForce (
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry
    );

    # Note: The following options won't work with nix.enable = false:
    # - optimise.* (daemon management)
    # - settings.* (daemon configuration)
    # - extraOptions (daemon configuration)
    # Configure these via Determinate Systems or /etc/nix/nix.conf instead
  };

  # Version système (nix-darwin attend un entier entre 1 et 6)
  system.stateVersion = lib.mkDefault 6;
}
