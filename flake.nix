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
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    # Home Manager
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
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
    
    # Applications externes
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-master, home-manager, nixos-hardware, sops-nix, gitignore, ghostty, claude-desktop, ... }@inputs:
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
          hardwareType = "laptop";
          system = "x86_64-linux";
        };
      };

      # Configurations Home Manager standalone (pattern vdemeester)
      homeConfigurations = {
        "xophe@nixophe" = libx.mkHome {
          user = "xophe";
          hostname = "nixophe";
          desktop = "i3";
          system = "x86_64-linux";
        };
      };

      # Packages personnalisés (migration depuis default.nix)
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # Migration directe depuis default.nix
          univ = pkgs.callPackage ./tools/univ { };
          system = pkgs.callPackage ./tools/system { };
        }
      );

      # Overlays (système avancé pattern vdemeester)
      overlays = import ./overlays { inherit inputs; };

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
