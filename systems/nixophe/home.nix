{ pkgs, ... }:
{
  # TODO: building this file is in progress.
  imports = [
    ../../home/common/dev/containers.nix

    ../edfsf/home.nix
  ];

  home.packages = with pkgs; [
    spotify
  ];
}
