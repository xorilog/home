{
  description = "Configuration NixOS xophe/home - Migration architecture vdemeester";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    # Nixpkgs versions (basé sur sources.json analysées)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11"; 
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Emacs overlay (identifié dans sources.json)
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # NixOS hardware support (identifié dans sources.json)
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    
    # SOPS pour secrets (identifié dans sources.json) 
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Gitignore utilitaire (identifié dans sources.json)
    gitignore = {
      url = "github:hercules-ci/gitignore";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, emacs-overlay, nixos-hardware, sops-nix, gitignore, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";

      # Import de la librarie centralisée (pattern vdemeester)
      libx = import ./lib {
        inherit self inputs outputs stateVersion;
      };
      
      # Systèmes supportés
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Configurations NixOS (pattern vdemeester)
      nixosConfigurations = {
        # Machine principale
        nixophe = libx.mkHost {
          hostname = "nixophe";
          desktop = "i3";  # Depuis globals.nix
          system = "x86_64-linux";
        };
      };

      # Configurations Home Manager standalone (désactivé temporairement)
      # homeConfigurations = {
      #   "xophe@nixophe" = mkHome {
      #     username = "xophe";
      #     hostname = "nixophe";
      #     system = "x86_64-linux";
      #   };
      # };

      # Packages personnalisés (migration depuis default.nix)
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.callPackage ./default.nix {
          # Passage compatibilité sources -> inputs
          sources = {
            lib = nixpkgs.lib;
            pkgs = _: pkgs;
            pkgs-unstable = _: pkgs;  
            nixpkgs = _: pkgs;
          };
          inherit (pkgs) lib;
          inherit pkgs;
          pkgs-unstable = pkgs;
          nixpkgs = pkgs;
        }
      );

      # Overlays (export pour réutilisation)
      overlays = {
        default = final: prev: {
          # Migration depuis nix/overlays/
        };
        
        emacs = emacs-overlay.overlays.default;
        
        # Packages locaux
        local = final: prev: (self.packages.${prev.system} or {});
      };

      # Shells de développement
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "nixos-config-dev";
            buildInputs = with pkgs; [
              # Outils Nix
              nixfmt-rfc-style
              nil                 # Nix LSP
              nix-tree           # Exploration dépendances
              
              # Outils développement
              git
              gnumake
              
              # SOPS pour secrets
              sops
              age
              
              # Validation
              nixos-rebuild
              home-manager
            ];
            
            shellHook = ''
              echo "🏠 Environment de développement nixos-config activé"
              echo "📦 Flakes activés, commandes disponibles:"
              echo "   nix build .#nixosConfigurations.nixophe.config.system.build.toplevel"
              echo "   make build, make switch, make update"
            '';
          };
        }
      );

      # Formatage automatique
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      
      # Validation flake
      checks = forAllSystems (system: {
        # Validation build système
        nixos-build = self.nixosConfigurations.nixophe.config.system.build.toplevel;
        
        # Validation home-manager (désactivé temporairement)
        # home-manager-build = self.homeConfigurations."xophe@nixophe".activationPackage;
      });
    };
}