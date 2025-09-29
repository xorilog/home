{ pkgs ? (import ../nixpkgs.nix) { } }:
rec {
  # TODO: migrate things from nix/packages
  nixfmt-plus = pkgs.callPackage ./nixfmt-plus.nix { };
  # pre nur-packages import
  scripts = pkgs.callPackage ./my/scripts { };
  bekind = pkgs.callPackage ../tools/bekind { };

  # Mine
  ape = pkgs.callPackage ./ape { };

  # Maybe upstream
  govanityurl = pkgs.callPackage ./govanityurl { };
  batzconverter = pkgs.callPackage ./batzconverter { };
  prm = pkgs.callPackage ./prm { };

  # Upstream
  adi1090x-plymouth = pkgs.callPackage ./adi1090x-plymouth { };
}
