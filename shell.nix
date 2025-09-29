# Shell for bootstrapping flake-enabled nix and home-manager
# Access development shell with 'nix develop' or (legacy) 'nix-shell'
{
  system ? builtins.currentSystem,
}:

# Use flake.nix devshell, similar to "nix develop"
(builtins.getFlake (toString ./.)).devShells.${system}.default
