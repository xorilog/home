{
  lib,
  desktop,
  ...
}:
{
  imports = [
    ./ai.nix
    ./claude.nix
    ./go.nix
    ./nix.nix
    ./python.nix
    ./pre-commit.nix
    ./base.nix
  ]
  ++ lib.optional (builtins.isString desktop) ./desktop.nix;
}
