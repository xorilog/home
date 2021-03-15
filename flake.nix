# flake.nix --- the heart of my home
#
# Author:  Vincent Demeester <vincent@sbr.pm>
# URL:     https://git.srb.ht/~vdemeester/home
# License: GPLv3
#
# Welcome to ground zero. Where the whole flake gets set up and all its modules
# are loaded.
#
{
  description = ''
    home is the personal mono-repo of Christophe Boucharlat based on Vincent Demeester's; containing the declarative
    configuration of servers, desktops, laptops - including dotfiles; a collection of packages;
  '';

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "master";
    };
    nixos = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-20.09";
    };
    nixos-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      ref = "master";
    };
    nix-darwin = {
      type = "github";
      owner = "LnL7";
      repo = "nix-darwin";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      type = "github";
      owner = "rycee";
      repo = "home-manager";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nyxt = {
      type = "github";
      owner = "atlas-engineer";
      repo = "nyxt";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gitignore-nix = {
      type = "github";
      owner = "hercules-ci";
      repo = "gitignore.nix";
      ref = "master";
      flake = false;
    };
  };

  outputs = { self, ... } @ inputs:
    with inputs.nixpkgs.lib;
    let
      # List systems that we support.
      # So far it is only amd64 and aarch64
      forEachSystem = genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];

      # mkPkgs makes pkgs for a system, given a pkgs attrset.
      # The pkgs attrset can be taken from inputs nixos, nixos-unstable, nixpkgs.
      mkPkgs = pkgs: system: import pkgs {
        inherit system;
        config = import ./nix/config.nix;
        overlays = self.internal.overlays."${system}";
      };
      unstablePkgsBySystem = forEachSystem (mkPkgs inputs.nixos-unstable);
      stablePkgsBySystem = forEachSystem (mkPkgs inputs.nixos);
      pkgsBySystem = forEachSystem (mkPkgs inputs.nixpkgs);

      /* Creates a Nix Darwin configuration from a name and an attribute set.
      */
      mkDarwinConfiguration = name: { pkgs
                                    , config ? ./systems/hosts + "/${name}.nix"
                                    , users ? [ "vincent" ]
                                    }:
        nameValuePair name (inputs.nix-darwin.lib.darwinsystem {
          modules = [
            (
              ({ inputs, ... }: {
                # Use the nixpkgs from the flake.
                nixpkgs = { pkgs = pkgsBySystem."${system}"; };

                # For compatibility with nix-shell, nix-build, etc.
                environment.etc.nixpkgs.source = inputs.nixpkgs;
                nix.nixPath = [ "nixpkgs=/etc/nixpkgs" "darwin=${inputs.nix-darwin}" ];

                # Set system stuff
                system.checks.verifyNixPath = false;
                system.darwinVersion = lib.mkForce (
                  "darwin" + toString config.system.stateVersion + "." + inputs.nix-darwin.shortRev
                );
                system.darwinRevision = inputs.nix-darwin.rev;
                system.nixpkgsVersion =
                  "${nixpkgs.lastModifiedDate or nixpkgs.lastModified}.${nixpkgs.shortRev}";
                system.nixpkgsRelease = lib.version;
                system.nixpkgsRevision = nixpkgs.rev;
              })
                ({ pkgs, ... }: {
                  # Don't rely on the configuration to enable a flake-compatible version of Nix.
                  nix = {
                    package = pkgs.nixFlakes;
                    extraOptions = "experimental-features = nix-command flakes";
                  };
                })
                ({ lib, ... }: {
                  # Set the system configuration revision.
                  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
                })
                ({ inputs, ... }: {
                  # Re-expose self and nixpkgs as flakes.
                  nix.registry = {
                    self.flake = inputs.self;
                    nixpkgs = {
                      from = { id = "nixpkgs"; type = "indirect"; };
                      flake = inputs.nixpkgs;
                    };
                  };
                })
                (import ./systems/modules/default.flake.nix)
                (import config)
            )
          ];
        });

      /* Creates a NixOS configuration from a `name` and an attribute set.
         The attribute set is composed of:
         - pkgs: the package set to use. To be taken from the inputs (inputs.nixos, …)
         - system: the architecture of the system. Default is x86_64-linux.
         - config: the configuration path that will be imported
         - users: the list of user configuration to import
      */
      mkNixOsConfiguration = name: { pkgs
                                   , system ? "x86_64-linux"
                                   , config ? ./systems/hosts + "/${name}.flake.nix"
                                   , users ? [ "root" "vincent" ]
                                   }:
        # assert asserts.assertMsg (builtins.pathExists config) "${name} has no configuration, create one in ./systems/hosts/${name}.flake.nix";
        nameValuePair name (nixosSystem {
          inherit system;
          modules = [
            ({ name, ... }: {
              # Set the hostname to the name of the configuration being applied (since the
              # configuration being applied is determined by the hostname).
              networking.hostName = name;
            })
            ({ inputs, ... }: {
              # Use the nixpkgs from the flake.
              nixpkgs = { pkgs = pkgsBySystem."${system}"; };

              # For compatibility with nix-shell, nix-build, etc.
              environment.etc.nixpkgs.source = inputs.nixpkgs;
              nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
            })
            ({ pkgs, ... }: {
              # Don't rely on the configuration to enable a flake-compatible version of Nix.
              nix = {
                package = pkgs.nixFlakes;
                extraOptions = "experimental-features = nix-command flakes";
              };
            })
            ({ lib, ... }: {
              # Set the system configuration revision.
              system.configurationRevision = lib.mkIf (self ? rev) self.rev;
            })
            ({ inputs, ... }: {
              # Re-expose self and nixpkgs as flakes.
              nix.registry = {
                self.flake = inputs.self;
                nixpkgs = {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  flake = inputs.nixpkgs;
                };
              };
            })
            (import ./systems/modules/default.flake.nix)
            (import config)
          ]
          # Load user configuration based on the list of users passed.
          ++ (map (f: import (./users + ("/" + f + "/default.flake.nix"))) users);
          specialArgs = { inherit name inputs; };
        });

      /*
      mkHomeManagerConfiguration creates a home-manager configuration from a `name` (a user) and an attribute set.
      The attribute set is composed of:
      - config: the configuration path that will be imported, by default `./users/{name}/home.nix

      It loads home-manager specific modules and config and set a minimum set of configuration file
      to integrate with flakes a bit better.

      It can be used in a configuration as following:
      `home-manager.users.vincent = inputs.self.internal.homeManagerConfigurations."vincent";`.
      */
      mkHomeManagerConfiguration = name: { config ? ./users + "/${name}/home.nix" }:
        nameValuePair name ({ ... }: {
          imports = [
            (import ./users/modules)
            (import config)
          ];
          # For compatibility with nix-shell, nix-build, etc.
          home.file.".nixpkgs".source = inputs.nixpkgs;
          systemd.user.sessionVariables."NIX_PATH" =
            mkForce "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

          # Use the same Nix configuration throughout the system.
          xdg.configFile."nixpkgs/config.nix".source = ./nix/config.nix;

          # Re-expose self and nixpkgs as flakes.
          xdg.configFile."nix/registry.json".text = builtins.toJSON {
            version = 2;
            flakes =
              let
                toInput = input:
                  {
                    type = "path";
                    path = input.outPath;
                  } // (
                    filterAttrs
                      (n: _: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
                      input
                  );
              in
              [
                {
                  from = { id = "self"; type = "indirect"; };
                  to = toInput inputs.self;
                }
                {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  to = toInput inputs.nixpkgs;
                }
              ];
          };
        });
    in
    {
      # `internal` isn't a known output attribute for flakes. It is used here to contain
      # anything that isn't meant to be re-usable.
      # Taken from davidtwco/veritas repository :)
      internal = {

        # Expose the development shells defined in the repository, run these with:
        #
        # nix develop '.#devShells.x86_64-linux.cargo'
        devShells = forEachSystem (system:
          let
            pkgs = pkgsBySystem."${system}";
          in
          {
            # FIXME define your own here
            cargo = import ./nix/shells/cargo.nix { inherit pkgs; };
          }
        );

        # Attribute set of hostnames to home-manager modules with the entire configuration for
        # that host - consumed by the home-manager NixOS module for that host (if it exists)
        # or by `mkHomeManagerHostConfiguration` for home-manager-only hosts.
        homeManagerConfigurations = mapAttrs' mkHomeManagerConfiguration {
          xophe = { };
          vincent = { };
          root = { };
          houbeb = { };
        };

        # Overlays consumed by the home-manager/NixOS configuration.
        overlays = forEachSystem (system: [
          (self.overlay."${system}")
          (_: _: import inputs.gitignore-nix { lib = inputs.nixpkgs.lib; })
          #inputs.nyxt.overlay
          (import ./nix/overlays/infra.nix)
          (import ./nix/overlays/mkSecret.nix)
        ]);
      };

      # Attribute set of hostnames to be evaluated as NixOS configurations. Consumed by
      # `nixos-rebuild` on those hosts.
      nixosConfigurations = mapAttrs' mkNixOsConfiguration {
        # FIXME remove .flake "suffix" once they all got migrated
        nixophe = { pkgs = inputs.nixos-unstable; system = "x86_64-linux"; };
        # TODO VMs
        #foo = { pkgs = inputs.nixos-unstable; users = [ "vincent" "houbeb" "root" ]; };
      };

      # Attribute set of hostnames to be evaluated as nix-darwin configurations.
      darwinConfigurations = mapAttrs' mkDarwinConfiguration {
        honshu = { pkgs = inputs.nixpkgs; };
      };

      # Import the modules exported by this flake.
      # containerd, buildkit are interesting module to export from here
      nixosModules = {
        # Containerd hit upstream
        # containerd = import ./systems/modules/virtualisation/containerd.nix;
        buildkit = import ./systems/modules/virtualisation/buildkit.nix;
      };

      # Expose a dev shell which contains tools for working on this repository.
      devShell = forEachSystem (system:
        with pkgsBySystem."${system}";

        mkShell {
          name = "home";
          buildInputs = [
            cachix
            git-crypt
            nixpkgs-fmt
            gnumake
          ];
        }
      );

      # Expose an overlay which provides the packages defined by this repository.
      #
      # Overlays are used more widely in this repository, but often for modifying upstream packages
      # or making third-party packages easier to access - it doesn't make sense to share those,
      # so they in the flake output `internal.overlays`.
      #
      # These are meant to be consumed by other projects that might import this flake.
      overlay = forEachSystem (system: _: _: self.packages."${system}");

      # Expose the packages defined in this flake, built for any supported systems. These are
      # meant to be consumed by other projects that might import this flake.
      #
      # Internal packages are handled through overlay definition, in internal.
      # Note: they are also added to the systems overlay so there is no duplication of definition.
      packages = forEachSystem
        (system:
          let
            pkgs = pkgsBySystem."${system}";
          in
          {
            # FIXME Do I really need / want that
            apeStable = stablePkgsBySystem."${system}".callPackage ./nix/packages/ape { };
            apeUnstable = unstablePkgsBySystem."${system}".callPackage ./nix/packages/ape { };
            ape = pkgs.callPackage ./nix/packages/ape { };

            nr = pkgs.callPackage ./nix/packages/nr { };
            ram = pkgs.callPackage ./nix/packages/ram { };
            systemd-email = pkgs.callPackage ./nix/packages/systemd-email { };

            batzconverter = pkgs.callPackage ./nix/packages/batzconverter { };

            manifest-tool = pkgs.callPackage ./nix/packages/manifest-tool { };
            ko = pkgs.callPackage ./nix/packages/ko { };
            buildx = pkgs.callPackage ./nix/packages/buildx { };
            buildkit = pkgs.callPackage ./nix/packages/buildkit { };
          });

      # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    };
}
