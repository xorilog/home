{ pkgs, ... }:
{
  home.packages = [
    (builtins.getFlake "github:k3d3/claude-desktop-linux-flake").packages.${builtins.currentSystem}.claude-desktop-with-fhs
    pkgs.claude-code
  ];
}
