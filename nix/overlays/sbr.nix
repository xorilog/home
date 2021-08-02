self: super:
#let
#  compileEmacsFiles = super.callPackage ./emacs/builder.nix;
#in
rec {
  scripts = import ../packages/my/scripts {
    inherit (self) stdenv;
  };
  vde-thinkpad = import ../packages/my/vde-thinkpad {
    inherit (self) stdenv;
  };
  bekind = super.callPackage ../../tools/bekind { };

  my = import ../packages {
    inherit (self) pkgs;
  };
}
