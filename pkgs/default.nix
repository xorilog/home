{
  pkgs ? (import ../nixpkgs.nix) { },
}:
rec {
  # TODO: migrate things from nix/packages
  nixfmt-plus = pkgs.callPackage ./nixfmt-plus.nix { };
  # pre nur-packages import
  # named vde-scripts (not `scripts`): the additions overlay puts it at top-level,
  # where callPackage would inject it into any `scripts ? [ ]` argument (e.g. mpv).
  vde-scripts = pkgs.callPackage ./my/scripts { };
  bekind = pkgs.callPackage ../tools/bekind { };
  claude-hooks = pkgs.callPackage ../tools/claude-hooks { };

  # Mine
  ape = pkgs.callPackage ./ape { };

  # Maybe upstream
  batzconverter = pkgs.callPackage ./batzconverter { };
  prm = pkgs.callPackage ./prm { };

  # Bitwarden
  bitwarden-cli-bio = pkgs.callPackage ./bitwarden-cli-bio { };

  # Upstream
  adi1090x-plymouth = pkgs.callPackage ./adi1090x-plymouth { };
}
