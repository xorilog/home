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
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    nixpkgs-25_05 = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.05";
    };
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

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

    # Agenix pour secrets avec age
    agenix = {
      url = "github:ryantm/agenix";
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

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-master,
      home-manager,
      nixos-hardware,
      sops-nix,
      agenix,
      gitignore,
      ghostty,
      claude-desktop,
      ...
    }@inputs:
    # outputs = { self, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";

      # Import de la librarie centralisée (pattern vdemeester)
      libx = import ./lib {
        inherit
          self
          inputs
          outputs
          stateVersion
          ;
      };

      # Systèmes supportés
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # TODO: activate with github action.
      # githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
      #   checks = inputs.nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.packages;
      # };

      # Standalone home configurations
      # TODO: Do i really need this ?
      # FIXME set this up
      # homeConfigurations = {
      #   "xophe@nixophe" = libx.mkHome {
      #     username = "xophe";
      #     hostname = "nixophe";
      #     desktop = "i3";
      #     system = "x86_64-linux";
      #   };
      # };

      # Configurations NixOS
      nixosConfigurations = {
        # Work laptop (unstable)
        nixophe = libx.mkHost {
          hostname = "nixophe";
          desktop = "i3";
          hardwareType = "laptop";
          system = "x86_64-linux";
        };
      };

      nixosModules = {
        # provided modules (to be upstreamed)
        govanityurl = ./modules/govanityurl.nix;
        gosmee = ./modules/gosmee.nix;
      };

      overlays = import ./overlays { inherit inputs; };

      # Packages personnalisés (migration depuis default.nix)
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # Migration directe depuis default.nix
          system = pkgs.callPackage ./tools/system { };
        }
      );

      # Shells de développement
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "nixos-config-dev";
            buildInputs = with pkgs; [
              # Outils Nix
              nixfmt-rfc-style
              nil # Nix LSP
              nix-tree # Exploration dépendances

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
        # TODO: re enable later.
        # pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        #   src = ./.;
        #   hooks = {
        #     # go
        #     gofmt.enable = true;
        #     # golangci-lint.enable = true;
        #     # nix
        #     deadnix.enable = true;
        #     nixfmt-rfc-style.enable = true;
        #     # statix.enable = true;
        #     # python
        #     flake8.enable = true;
        #     ruff.enable = true;
        #     # shell
        #     shellcheck.enable = true;
        #   };
        # };

        # Validation build système
        nixos-build = self.nixosConfigurations.nixophe.config.system.build.toplevel;

        # Validation home-manager (désactivé temporairement)
        # home-manager-build = self.homeConfigurations."xophe@nixophe".activationPackage;
      });
    };
}
