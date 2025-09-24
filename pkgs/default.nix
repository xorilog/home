{ pkgs }:
rec {
  # pre nur-packages import
  scripts = pkgs.callPackage ./my/scripts { };
  vrsync = pkgs.callPackage ./my/vrsync { };
  bekind = pkgs.callPackage ../tools/bekind { };

  # Mine
  ape = pkgs.callPackage ./ape { };
  fhs-std = pkgs.callPackage ./fhs/std.nix { };
  nr = pkgs.callPackage ./nr { };

  # Maybe upstream
  govanityurl = pkgs.callPackage ./govanityurl { };
  batzconverter = pkgs.callPackage ./batzconverter { };
  prm = pkgs.callPackage ./prm { };

  # Upstream
  buildkit = pkgs.callPackage ./buildkit { };
  buildx = pkgs.callPackage ./buildx { };
  adi1090x-plymouth = pkgs.callPackage ./adi1090x-plymouth { };
}
