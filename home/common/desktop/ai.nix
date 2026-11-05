{ pkgs, inputs, ... }:
{
  home.packages = [
    # k3d3/claude-desktop-linux-flake is unmaintained (breaks on nodePackages removal);
    # llm-agents ships a maintained build.
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
  ];
}
