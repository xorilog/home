{
  self,
  inputs,
  outputs,
  stateVersion,
  ...
}:
{
  # Fonction utilitaire (basique, à développer)
  libx = import ./functions.nix { inherit (inputs.nixpkgs) lib; };
  
  # Fonction pour générer les configurations home-manager (pattern vdemeester)
  mkHome = {
    hostname,
    user,
    desktop ? null,
    system ? "x86_64-linux",
  }:
  let
    globals = import ../globals.nix {
      inherit (inputs.nixpkgs) lib;
      inherit hostname;
    };
  in
  inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    extraSpecialArgs = {
      inherit
        self
        inputs
        outputs
        stateVersion
        hostname
        desktop
        globals
        ;
      username = user;
      libx = import ./functions.nix { inherit (inputs.nixpkgs) lib; };
    };
    modules = [
      ../home
    ];
  };

  # Fonction pour générer les configurations host NixOS (pattern vdemeester)
  mkHost = {
    hostname,
    desktop ? null,
    hardwareType ? "",
    system ? "x86_64-linux",
    pkgsInput ? inputs.nixpkgs,
    homeInput ? inputs.home-manager,
  }:
  let
    globals = import ../globals.nix {
      inherit (pkgsInput) lib;
      inherit hostname;
    };
    specialArgs = {
      inherit
        self
        inputs
        outputs
        stateVersion
        hostname
        desktop
        hardwareType
        system
        globals
        ;
      libx = import ./functions.nix { inherit (pkgsInput) lib; };
    };
  in
  pkgsInput.lib.nixosSystem {
    inherit specialArgs;
    inherit system;
    modules = [
      # Modules personnalisés (TODO: à créer)
      # self.nixosModules.exemple

      # Modules externes
      inputs.sops-nix.nixosModules.sops
      inputs.agenix.nixosModules.default
      homeInput.nixosModules.home-manager

      # Configuration home-manager
      {
        home-manager = {
          extraSpecialArgs = specialArgs;
        };
      }

      # Point d'entrée systems/
      ../systems
    ];
  };
}
