{ inputs, ... }:
{
  # Custom packages (from ../pkgs directory)
  additions = final: _prev:
    let
      pkgsPath = ../pkgs;
    in
    if builtins.pathExists pkgsPath
    then {
      my = import pkgsPath { pkgs = final; };
    } // (import pkgsPath { pkgs = final; })
    else {};

  # Package modifications and overrides
  modifications = final: prev: {
    # Example modifications:
    # custom-package = prev.package.overrideAttrs (oldAttrs: {
    #   # customizations
    # });
    
    # Ghostty and Claude from inputs (if needed as overlay)
    # ghostty = inputs.ghostty.packages.${final.system}.ghostty;
    # claude-desktop = inputs.claude-desktop.packages.${final.system}.claude-desktop-with-fhs;
  };

  # Access to different nixpkgs versions
  unstable-packages = final: _prev: {
    # Master branch packages (bleeding edge)
    master = import inputs.nixpkgs-master {
      inherit (final) system;
      config.allowUnfree = true;
    };
    
    # Unstable packages (nixos-unstable)
    unstable = import inputs.nixpkgs {
      inherit (final) system;
      config.allowUnfree = true;
    };
    
    # Stable packages (24.11 stable)
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}