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

    niri = {
      type = "github";
      owner = "sodiboo";
      repo = "niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-25_05";
    };

    # NixOS hardware support (identifié dans sources.json)
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      "repo" = "nixos-hardware";
    };

    # NixOS Darwin support
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SOPS pour secrets (identifié dans sources.json)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix-25_05.url = "github:ryantm/agenix";
    agenix-25_05.inputs.nixpkgs.follows = "nixpkgs-25_05";

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
        "aarch64-darwin"
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

      darwinConfigurations = {
        xophe-mbp = libx.mkDarwinHost {
          hostname = "xophe-mbp";
          system = "aarch64-darwin";
        };
      };

      nixosModules = {
        # provided modules (to be upstreamed)
        govanityurl = ./modules/govanityurl.nix;
        gosmee = ./modules/gosmee.nix;
      };

      overlays = import ./overlays { inherit inputs; };

      # TODO: Document the bellow definition to build Darwin stuff at some point.
      packages = forAllSystems (
        system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowAliases = false;
            overlays = [
              self.overlays.additions
            ];
          };
          skipDarwinPackages =
            system: n:
            if lib.strings.hasSuffix "darwin" system then !(lib.strings.hasPrefix "koff" n) else true;
          inherit (inputs.nixpkgs) lib;
          drvAttrs = builtins.filter (n: lib.isDerivation pkgs.${n} && skipDarwinPackages system n) (
            builtins.attrNames (self.overlays.additions pkgs pkgs)
          );
        in
        lib.listToAttrs (map (n: lib.nameValuePair n pkgs.${n}) drvAttrs)
      );

      devShells = forAllSystems (system: {
        default =
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in
          inputs.nixpkgs.legacyPackages.${system}.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
            packages = [
              pkgs.git
              pkgs.nodePackages.prettier
              pkgs.deadnix
              pkgs.nixfmt-rfc-style
              pkgs.ripgrep
              inputs.agenix.packages.${system}.default
            ];
            name = "home";
            DIRENV_LOG_FORMAT = "";
          };
      });

      # Formatage automatique
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Validation flake
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # go
            gofmt.enable = true;
            # golangci-lint.enable = true;
            # nix
            # TODO: re enable deadnix later.
            #deadnix.enable = true;
            nixfmt-rfc-style.enable = true;
            # statix.enable = true;
            # python
            flake8.enable = true;
            ruff.enable = true;
            # shell
            shellcheck.enable = true;
          };
        };

        # Validation build système
        nixos-build = self.nixosConfigurations.nixophe.config.system.build.toplevel;

        # Validation home-manager (désactivé temporairement)
        # home-manager-build = self.homeConfigurations."xophe@nixophe".activationPackage;
      });
    };
}
